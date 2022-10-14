// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);

}

contract Payments {

    address OWNER;
    IERC20 usdt;

    constructor() {
        OWNER = 0x075D29D70FF3d5AD1a2569bba6F581CBf2be7Cee; //Aqui va la address owner
        usdt = IERC20(address(0x337610d27c682E347C9cD60BD4b3b107C9d34dDd));  //USDT in BSC testnet
    }

    struct Employees {
        uint amount;
        address payable addressUser;
    }

    Employees[] private employeesArray;

    struct Bonus {
        uint amount;
        address payable addressUser;
    }

    Bonus[] private bonusArray;

    //----------------Crear y Eliminar empleados
    function createEmployees(uint _amount, address payable _addressUser) onlyOwner public {
        employeesArray.push(Employees(_amount, _addressUser));
    }

    function deleteEmployees(uint _index) onlyOwner public {
        employeesArray[_index] = employeesArray[employeesArray.length - 1];
        employeesArray.pop();
    }

    //----------------Crear y Eliminar bonos
    function createbonus(uint _amount, address payable _addressUser) onlyOwner public {
        bonusArray.push(Bonus(_amount, _addressUser));
    }

    function deletebonus(uint _index) onlyOwner public {
        bonusArray[_index] = bonusArray[employeesArray.length - 1];
        bonusArray.pop();
    }

    //----------------Approve
    function approveUsdt(address _spender, uint256 _amount) onlyOwner public {
        usdt.approve(_spender, _amount);
    }

    //----------------Contract Balance
    function getContractBalance() public view returns (uint) {
        return usdt.balanceOf(address(this));
    }

    //----------------Pagos salarios
    function salaryPay(uint _index) onlyOwner public payable {
        uint amount = employeesArray[_index].amount;
        address payable addressUser = employeesArray[_index].addressUser;

        usdt.transfer(addressUser, amount);
    }

    function salaryPayments() onlyOwner public payable {
        uint arrayLength = employeesArray.length;
        for (uint i=0; i<arrayLength; i++) {
            salaryPay(i);
            i+1;
        }
    }

    //----------------Pagos Bonos
    function bonusPays(uint _index) onlyOwner public payable {
        uint amount = bonusArray[_index].amount;
        address payable addressUser = bonusArray[_index].addressUser;

        usdt.transfer(addressUser, amount);
    }

    function bonusPayments() onlyOwner public payable {
        uint arrayLength = bonusArray.length;
        for (uint i=0; i<arrayLength; i++) {
            bonusPays(i);
            i+1;
        }
        delete bonusArray;    //Restart array
    }

    modifier onlyOwner() {
        require(OWNER == msg.sender, "You are not the owner");
        _;
    }
  
}