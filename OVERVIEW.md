# Blockscout Overview

Blockscout is an open-source blockchain explorer for Ethereum Virtual Machine (EVM) chains.

## Architecture

Blockscout is built as an Elixir umbrella project, consisting of several specialized applications:

- **`block_scout_web`**: The Phoenix-based web interface and API (REST/GraphQL).
- **`explorer`**: The core logic and database layer (PostgreSQL via Ecto). Handles data models like Blocks, Transactions, Addresses, and Tokens.
- **`indexer`**: The ETL (Extract, Transform, Load) layer that fetches data from blockchain nodes and imports it into the database.
- **`ethereum_jsonrpc`**: The client for communicating with Ethereum nodes using JSON-RPC.
- **`nft_media_handler`**: Handles processing of NFT-related media.

## Key Technologies

- **Language**: Elixir / Erlang (BEAM)
- **Web**: Phoenix Framework
- **Database**: PostgreSQL
- **Blockchain Interface**: JSON-RPC (WebSockets & Polling)

## Key Features

- Real-time indexing of blocks and transactions.
- Smart contract verification and interaction.
- Support for ERC-20, ERC-721, and ERC-1155 tokens.
- Internal transaction tracking.
- Etherscan-compatible API.
