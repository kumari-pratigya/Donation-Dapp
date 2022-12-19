// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';

contract Fundraiser is Ownable {
  using SafeMath for uint256;

  struct Donation {
    uint256 value;
    uint256 date;
    
  }
  struct Data{
      uint Amount;
      address Address;
      uint Date;
  }
   
  mapping(uint=>Data) public dataById;
  uint public id=1;
  
  Data[] public datas;
 

 

  mapping(address => Donation[]) public _donations;

  event DonationReceived(address indexed donor, uint256 value);
  event Withdraw(uint256 amount);

  string public name;
  string public image;
  string public description;
  address payable public beneficiary;
  uint256 public goalAmount;
  string public facebookLink;
  string public linkedinLink;
  string public twitterLink;
  uint256 public totalDonations;
  uint256 public donationsCount;

  constructor(
    string memory _name,
    string memory _image,
    string memory _description,
    uint256 _goalAmount,
    string memory _facebookLink,
    string memory _linkedinLink,
    string memory _twitterLink,
    address payable _beneficiary,
    address _custodian
  ) public {
    name = _name;
    image = _image;
    description = _description;
    goalAmount = _goalAmount;
    facebookLink =_facebookLink;
    linkedinLink =_linkedinLink;
    twitterLink = _twitterLink;
    beneficiary = _beneficiary;
    _transferOwnership(_custodian);
  }

  function setBeneficiary(address payable _beneficiary) public onlyOwner {
    beneficiary = _beneficiary;
  }

  function myDonationsCount() public view returns (uint256) {
    return _donations[msg.sender].length;
  }
  
  //----------------------------------------------------------------------------------------------------------------
 

function getAllDonation() public view returns (uint[] memory 
   ){
      uint[] memory Amount = new uint[](id);
      address[] memory Address = new address[](id);
      uint[] memory Date = new uint[](id);
      for (uint i = 1; i < id; i++) {
          Data storage _data = dataById[i];
          Amount[i] = _data.Amount;
          Address[i] = _data.Address;
          Date[i] = _data.Date;
      }
      return (Amount );
  }




  function dataByIndex(uint _id) public view returns(Data memory){
      return dataById[_id];
  }

 
   
  //---------------------------------------------------------------------------------------------------------------

  function donate() public payable {
    Data storage NewData = dataById[id];
    NewData.Amount=msg.value;
    NewData.Address=msg.sender;
    NewData.Date=block.timestamp;

    datas.push(Data({Amount:msg.value, Address:msg.sender, Date:block.timestamp}));
    Donation memory donation = Donation({
      value: msg.value,
      date: block.timestamp
    });
    _donations[msg.sender].push(donation);
    totalDonations = totalDonations.add(msg.value);
    donationsCount++;
    id++;

    emit DonationReceived(msg.sender, msg.value);
  }

  function myDonations() public view returns (
      uint256[] memory values,
      uint256[] memory dates
  )

  {
    uint256 count = myDonationsCount();
    values = new uint256[](count);
    dates = new uint256[](count);
    for (uint256 i = 0; i < count; i++) {
        Donation storage donation = _donations[msg.sender][i];
        values[i] = donation.value;
        dates[i] = donation.date;
    }
    return (values, dates);
  }

  function withdraw() public onlyOwner {
      uint256 balance = address(this).balance;
      beneficiary.transfer(balance);
      emit Withdraw(balance);
  }

  fallback() external payable {
      totalDonations = totalDonations.add(msg.value);
      donationsCount++;
  }

}