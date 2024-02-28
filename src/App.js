import { useEffect, useState } from 'react';
import { ethers } from 'ethers';

// Components
import Navigation from './components/Navigation';
import Search from './components/Search';
import Home from './components/Home';

// ABIs
import RealEstate from './abis/RealEstate.json'
import Escrow from './abis/Escrow.json'

// Config
import config from './config.json';

function App() {

  const [account, setAccount] = useState(null);

  // Load blockchain data
  const loadBlockkchainData = async () => {
    const provider = new ethers.providers.Web3Provider(window.ethereum);

    // Watch for account changes
    window.ethereum.on('accountsChanged', async () => {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      const account = ethers.utils.getAddress(accounts[0]);
      setAccount(account);
    });
  }

  useEffect(() => {
    loadBlockkchainData();
  }, []);

  return (
    <div>
      <Navigation account={account} setAccount={setAccount} />
      <Search />
      <div className='cards__section'>

        <h3>Homes for you</h3>
        <hr />

        <div className='cards'>
          <div className='card'>
            <div className='card__image'>
              <img src='' alt='Home' />
            </div>

            <div className='card__info'>
              <h4>1 ETH</h4>
              <p>
                <strong>1</strong> beds |
                <strong> 2</strong> baths |
                <strong> 3</strong> sqft.
              </p>
              <p>1234 Elm St.</p>
            </div>
          </div>
        </div>

      </div>

    </div>
  );
}

export default App;
