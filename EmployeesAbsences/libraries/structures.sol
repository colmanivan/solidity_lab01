// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library StructuresLibrary {
    struct EmployeeStruct{
        bytes32 Id;
        string Name;
        string Surname;
        uint FileNumber;
        uint Age;
    }
}