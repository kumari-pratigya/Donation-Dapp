import React,{useEffect} from 'react'
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import FundraiserFactory from 'contracts/Fundraiser.json';
const History = () => {
  useEffect(() => {
    init();
  }, []);
  const web3 = new Web3(
    new Web3.providers.HttpProvider('https://rpc-mumbai.maticvigil.com'),
  );
  const init = async () => {
    try {
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = FundraiserFactory.networks[networkId];
      const accounts = await web3.eth.getAccounts();
      const instance = new web3.eth.Contract(
        FundraiserFactory.abi,
        deployedNetwork && deployedNetwork.address,
      );
      // setContract(instance);
      // setAccounts(accounts);
      // const indexDetails = await instance.methods.dataByIndex(1).call();
      const funds = await instance.methods.getAllDonation.call();
      // setFunds(funds);
      console.log('------', funds);
    //   const donate = await instance.methods.donate.call();
    // console.log(donate,'donate*****************888')
      // console.log('-------',indexD)
      // setFunds(funds);
    } catch (error) {
      console.error(error);
    }
  };
 const funds=[{
    Date:"12-4-2022",
    address:"0xFD4b3116DE351eB12352Bc8C23AcCC9545a60dB2",
    Amount:"10"
  },
{
  Date:"12-4-2022",
  address:"0xFD4b3116DE351eB12352Bc8C23AcCC9545a60dB2",
  Amount:"10"
}]

  return (
    <div >
      <h1> Transaction History</h1>
     { funds.map((item,i)=>
  <div key={i} className='container' style={
    {width:"auto",
    margin:" 10px auto",
    border:"1px solid black",
    borderRadius:"3px",
    padding:"10px"}}>
    <p>Date: {item.Date}</p>
    <p>Address: {item.address}</p>
    <p>Amount:{item.Amount}</p>
  </div>
    )
     }
    </div>
  )
}

export default History
