
# Ether Homes

Ether Homes is a full-stack real estate marketplace built on top of the Ethereum blockchain. Property listings are transformed into a collection of non-fungible tokens (NFT), allowing users to easily complete each step of the escrow process and view the entire ownership history of each property.

## Tech Stack

**Client:** JavaScript, React.JS, Ether.JS

**Server:** Solidity, Hardhat, Node, OpenZeppelin, I.P.F.S.


## Features

- Full Escrow Process (Appraisal, Lending, Inspection)
- Create and Mint New Property NFTs
- Test Suites for Smart Contracts
- Deployable Smart Contracts onto the Blockchain
- Client Integration with MetaMask
- Authorization of different Users for the Escrow process


## Deployment & Testing

To run the test suites, run the following command:

```bash
  npx hardhat test
```

To run blockchain nodes locally with hardhat, run the following command:

```bash
  npx hardhat node
```

To deploy the smart contracts locally, run the following command:

```bash
  npx hardhat run scripts/deploy.js --network localhost
```

## License

[MIT](https://choosealicense.com/licenses/mit/)

