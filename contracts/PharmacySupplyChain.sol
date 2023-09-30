// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PharmacySupplyChain {
    address public owner;

    enum MedicineStatus { Created, InTransit, Delivered, Sold }

    struct Medicine {
        uint256 id;
        string name;
        uint256 quantity;
        address manufacturer;
        address pharmacy;
        address consumer;
        MedicineStatus status;
        uint256 mfdDate;
        uint256 expDate;
    }

    mapping(uint256 => Medicine) public medicines;
    uint256 public medicineCount;

    event MedicineCreated(uint256 id, string name, uint256 quantity, uint256 mfdDate, uint256 expDate);
    event MedicineInTransit(uint256 id);
    event MedicineDelivered(uint256 id);
    event MedicineSold(uint256 id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createMedicine(string memory _name, uint256 _quantity, uint256 _mfdDate, uint256 _expDate) public onlyOwner {
        medicineCount++;
        medicines[medicineCount] = Medicine(medicineCount, _name, _quantity, msg.sender, address(0), address(0), MedicineStatus.Created, _mfdDate, _expDate);
        emit MedicineCreated(medicineCount, _name, _quantity, _mfdDate, _expDate);
    }

    function startMedicineShipment(uint256 _id, address _pharmacy) public onlyOwner {
        Medicine storage medicine = medicines[_id];
        require(medicine.status == MedicineStatus.Created, "Medicine is not in Created state");
        medicine.status = MedicineStatus.InTransit;
        medicine.pharmacy = _pharmacy;
        emit MedicineInTransit(_id);
    }

    function receiveMedicine(uint256 _id) public {
        Medicine storage medicine = medicines[_id];
        require(msg.sender == medicine.pharmacy, "Only pharmacy can receive the medicine");
        require(medicine.status == MedicineStatus.InTransit, "Medicine is not in Transit state");
        medicine.status = MedicineStatus.Delivered;
        emit MedicineDelivered(_id);
    }

    function sellMedicine(uint256 _id, address _consumer) public onlyOwner {
        Medicine storage medicine = medicines[_id];
        require(medicine.status == MedicineStatus.Delivered, "Medicine is not in Delivered state");
        require(medicine.consumer == address(0), "Medicine has already been sold to a consumer");
        medicine.status = MedicineStatus.Sold;
        medicine.consumer = _consumer;
        emit MedicineSold(_id);
    }

    function getMedicineStatus(uint256 _id) public view returns (MedicineStatus) {
        return medicines[_id].status;
    }

    function getMedicineMfdDate(uint256 _id) public view returns (uint256) {
        return medicines[_id].mfdDate;
    }

    function getMedicineExpDate(uint256 _id) public view returns (uint256) {
        return medicines[_id].expDate;
    }

     function getMedicineid(uint256 _id) public view returns (uint256) {
        return medicines[_id].id;
    }
}
