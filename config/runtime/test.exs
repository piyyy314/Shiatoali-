import Config

alias EthereumJSONRPC.Variant

######################
### BlockScout Web ###
######################

config :block_scout_web, BlockScoutWeb.API.V2, enabled: true

########################
### Ethereum JSONRPC ###
########################

################
### Explorer ###
################

config :explorer, Explorer.Chain.Cache.Counters.AverageBlockTime, enabled: false

config :explorer, Explorer.Chain.Cache.Counters.Transactions24hCount,
  enabled: false,
  cache_period: ConfigHelper.parse_time_env_var("CACHE_TRANSACTIONS_24H_STATS_PERIOD", "1h"),
  enable_consolidation: false

config :explorer, Explorer.Chain.Cache.Counters.NewPendingTransactionsCount, enabled: false

variant = Variant.get()

Code.require_file("#{variant}.exs", "apps/explorer/config/test")

###############
### Indexer ###
###############

Code.require_file("#{variant}.exs", "apps/indexer/config/test")
