// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import {StructuresLibrary} from "../libraries/structures.sol";

contract EnterpriseContract {
    // properties
    address private contractOwner;
    StructuresLibrary.EmployeeStruct[] employees;

    // constructor
    constructor(){
        contractOwner = msg.sender;
    }

    // events
    event event_CreateEmployee(StructuresLibrary.EmployeeStruct);
    event event_RemoveEmployee(StructuresLibrary.EmployeeStruct);

    // public methods
    function GetAllEmployees() public view returns(StructuresLibrary.EmployeeStruct[] memory) {
        return employees;
    }

    function CreateEmployee(string memory name, string memory surname, uint fileNumber, uint age) public payable OnlyOwner() modif_NotNullOrEmptyString(name, "Name") modif_PositiveNumber(fileNumber, "FileNumber") {
        UniqueFileNumber(fileNumber);
        bytes32 id = keccak256(abi.encodePacked(name, fileNumber));
        StructuresLibrary.EmployeeStruct memory employee = StructuresLibrary.EmployeeStruct(id, name, surname, fileNumber, age);
        employees.push(employee);
        emit event_CreateEmployee(employee);
    }

    function RemoveEmployee(bytes32 id) public payable OnlyOwner() {
        uint index = GetIndexEmployee(id);
        emit event_RemoveEmployee(employees[index]);
        PopEmployee(index);
    }

    // modifiers
    modifier OnlyOwner {
        require (msg.sender == contractOwner, "Unauthorized. You are not the Owner.");
        _;
    }

    modifier modif_NotNullOrEmptyString(string memory value, string memory propertyName) {
        string memory message = string(abi.encodePacked(propertyName," is required"));
        require (bytes(value).length > 0, message);
        _;
    }

    modifier modif_PositiveNumber(uint value, string memory propertyName) {
        string memory message = string(abi.encodePacked(propertyName," must be greater than zero"));
        require (value > 0, message);
        _;
    }

    // private functions
    function PopEmployee(uint index) private {
        employees[index] = employees[employees.length - 1];
        employees.pop();
    }

    function GetIndexEmployee(bytes32 id) private returns(uint) {
        for (uint i; i < employees.length; i++) {
            if (employees[i].Id == id) {
                return i;
            }
        }
    }

    // requires
    function UniqueFileNumber(uint fileNumber) private{
        bool isUnique = true;
        for (uint i; i < employees.length; i++) {
            if (employees[i].FileNumber == fileNumber) {
                isUnique = false;
                break;
            }
        }
        require(isUnique, "File Number exists.");
    }
}