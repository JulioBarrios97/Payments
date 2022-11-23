// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address _to, uint256 _value) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract Payments is Ownable {
    uint256[] indexLocal;
    uint256[] id;
    uint256[] amountLocal;
    IERC20 usdt;

    constructor() {
        usdt = IERC20(address(0x337610d27c682E347C9cD60BD4b3b107C9d34dDd));
    }

    enum Status {
        Enable,
        Disable
    }

    struct Employees {
        uint256 ID;
        uint256 amount;
        address payable addressUser;
        Status status;
    }

    Employees[] private employeesArray;

    struct Bonus {
        uint256 ID;
        uint256 amount;
        address payable addressUser;
    }

    Bonus[] private bonusArray;

    //----------------Create, Delete, Get and Edit Data employees

    function createEmployees(
        uint256 _ID,
        uint256 _amount,
        address payable _addressUser
    ) public onlyOwner {
        employeesArray.push(
            Employees(_ID, _amount, _addressUser, Status.Enable)
        );
    }

    function deleteEmployees(uint256 _index) public onlyOwner {
        employeesArray[_index] = employeesArray[employeesArray.length - 1];
        employeesArray.pop();
    }

    function editEmployee(
        uint256 _index,
        uint256 _ID,
        uint256 _amount,
        address payable _addressUser
    ) public onlyOwner {
        employeesArray[_index] = employeesArray[employeesArray.length - 1];
        employeesArray.pop();
        employeesArray.push(
            Employees(_ID, _amount, _addressUser, Status.Enable)
        );
    }

    function getDataEmployees(uint256 _ID)
        public
        view
        onlyOwner
        returns (
            uint256 index,
            uint256 amount,
            address addressUser,
            Status status
        )
    {
        uint256 arrayLength = employeesArray.length;
        for (uint256 i = 0; i < arrayLength; i++) {
            if (employeesArray[i].ID == _ID) {
                index = i;
                amount = employeesArray[i].amount;
                addressUser = employeesArray[i].addressUser;
                status = employeesArray[i].status;
            } else {
                i + 1;
                continue;
            }
        }
    }

    //----------------Create, Delete, Get and Edit Data bonuses

    function createBonus(
        uint256 _ID,
        uint256 _amount,
        address payable _addressUser
    ) public onlyOwner {
        bonusArray.push(Bonus(_ID, _amount, _addressUser));
    }

    function deleteBonus(uint256 _index) public onlyOwner {
        bonusArray[_index] = bonusArray[bonusArray.length - 1];
        bonusArray.pop();
    }

    function editBonus(
        uint256 _index,
        uint256 _ID,
        uint256 _amount,
        address payable _addressUser
    ) public onlyOwner {
        bonusArray[_index] = bonusArray[bonusArray.length - 1];
        bonusArray.pop();
        bonusArray.push(Bonus(_ID, _amount, _addressUser));
    }

    function getDataBonus(uint256 _ID)
        public
        view
        onlyOwner
        returns (
            uint256 index,
            uint256 amount,
            address addressUser
        )
    {
        uint256 arrayLength = bonusArray.length;
        for (uint256 i = 0; i < arrayLength; i++) {
            if (bonusArray[i].ID == _ID) {
                index = i;
                amount = bonusArray[i].amount;
                addressUser = bonusArray[i].addressUser;
            } else {
                i + 1;
                continue;
            }
        }
    }

    //-----------------Change Status, Approve, Get Contract Balance, Get All Employees

    function changeStatus(uint256 _index, uint256 _value) public onlyOwner {
        employeesArray[_index].status = Status(_value);
    }

    function approveUsdt(address _spender, uint256 _amount) public onlyOwner {
        usdt.approve(_spender, _amount);
    }

    function getContractBalance() public view onlyOwner returns (uint256) {
        //También onlyOwner
        return usdt.balanceOf(address(this));
    }

    function getAllEmployees()
        public
        onlyOwner
        returns (
            uint256[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        delete indexLocal;
        delete id;
        delete amountLocal;
        uint256 arrayLength = employeesArray.length;
        for (uint256 i = 0; i < arrayLength; i++) {
            indexLocal.push(i);
            id.push(employeesArray[i].ID);
            amountLocal.push(employeesArray[i].amount);
            i + 1;
        }
        return (indexLocal, id, amountLocal);
    }

    //----------------Payments salary

    function salaryPay(uint256 _index)
        public
        payable
        onlyOwner
        returns (string memory status)
    {
        if (employeesArray[_index].status == Status.Enable) {
            uint256 amount = employeesArray[_index].amount;
            address payable addressUser = employeesArray[_index].addressUser;

            usdt.transfer(addressUser, amount);
        } else {
            status = "Status disable";
            return status;
        }
    }

    function salaryPayments() public payable onlyOwner {
        uint256 arrayLength = employeesArray.length;
        for (uint256 i = 0; i < arrayLength; i++) {
            salaryPay(i);
            i + 1;
        }
    }

    //----------------Payments bonus

    function bonusPays(uint256 _index) public payable onlyOwner {
        uint256 amount = bonusArray[_index].amount;
        address payable addressUser = bonusArray[_index].addressUser;

        usdt.transfer(addressUser, amount);
    }

    function bonusPayments() public payable onlyOwner {
        uint256 arrayLength = bonusArray.length;
        for (uint256 i = 0; i < arrayLength; i++) {
            bonusPays(i);
            i + 1;
        }
        delete bonusArray; //Restart array
    }
}
