# Blockscout Project Overview

This document provides a high-level explanation of the Blockscout codebase.

## Architecture: Elixir Umbrella Project
The codebase is organized as an Elixir umbrella project, where specialized services work together:

*   **`block_scout_web`**: The user-facing layer. Built with the **Phoenix Framework**, it serves the web UI and exposes multiple API interfaces (REST v1/v2, an Etherscan-compatible RPC API, and a GraphQL API via Absinthe).
*   **`explorer`**: The core domain layer. It handles the business logic, manages the **PostgreSQL** database schemas, and provides the data access layer used by the web UI.
*   **`indexer`**: The ETL (Extract, Transform, Load) engine. It fetches raw data from blockchain nodes, transforms it into a searchable format, and persists it via the `explorer` application.
*   **`ethereum_jsonrpc`**: The communication bridge. It provides adapters and transport logic for interacting with various Ethereum node clients like Geth, Besu, and Nethermind.
*   **`nft_media_handler`**: A specialized service for fetching and processing NFT (ERC-721/1155) metadata and media, including thumbnail generation and S3 storage.
*   **`utils`**: Contains shared helper modules and configuration logic used across the other applications.

## Technology Stack
*   **Backend**: Elixir 1.19 (OTP 27) and Erlang.
*   **Database**: PostgreSQL (v10.3+).
*   **Frontend**: A hybrid approach using server-side rendered Phoenix views with client-side enhancements via **React**, **Redux**, and **Bootstrap 4**. Assets are bundled using **Webpack**.
*   **APIs**: REST (v1 & v2), RPC (JSON-RPC), and GraphQL.

## Key Features
*   **Chain Exploration**: Real-time monitoring of blocks, transactions, and account balances.
*   **Smart Contract Verification**: Supports source code verification for **Solidity** and **Vyper**, detecting proxy patterns and integrating with services like Sourcify.
*   **Token Tracking**: Comprehensive indexing of ERC-20, ERC-721, and ERC-1155 tokens and transfers.
*   **Layer 2 Support**: Specialized indexing and features for L2 solutions like **Optimism**, **Arbitrum**, **Polygon zkEVM**, and **Scroll**.
*   **Multi-Mode Operation**: Can be configured via environment variables to run as a full explorer, an indexer-only node, or an API-only instance.

## Configuration & Deployment
The project is designed for high configurability, with most settings managed through environment variables (defined and loaded in `config/runtime.exs`). It supports multiple deployment methods including Docker Compose, Kubernetes, and Ansible.
