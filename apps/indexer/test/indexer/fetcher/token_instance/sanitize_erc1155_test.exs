defmodule Indexer.Fetcher.TokenInstance.SanitizeERC1155Test do
  use Explorer.DataCase

  import Mox

  alias Explorer.Repo
  alias Explorer.Chain.Token.Instance

  setup :verify_on_exit!
  setup :set_mox_global

  describe "sanitizer test" do
    setup do
      stub(EthereumJSONRPC.Mox, :json_rpc, fn
        requests, _options when is_list(requests) ->
          {:ok, Enum.map(requests, fn %{id: id} -> %{id: id, result: "0x"} end)}

        %{id: id, method: "eth_blockNumber"}, _options ->
          {:ok, %{id: id, result: "0x1"}}

        request, _options when is_map(request) ->
          {:ok, %{id: Map.get(request, :id, 0), result: "0x"}}
      end)

      :ok
    end

    test "imports token instances" do
      for i <- 0..3 do
        token = insert(:token, type: "ERC-1155")

        insert(:address_current_token_balance,
          token_type: "ERC-1155",
          token_id: i,
          token_contract_address_hash: token.contract_address_hash,
          value: Enum.random(1..100_000)
        )
      end

      # Mock the ERC-1155 uri() calls to return errors so instances get error field populated
      stub(EthereumJSONRPC.Mox, :json_rpc, fn
        [%{method: "eth_call"} | _] = requests, _options ->
          {:ok,
           Enum.map(requests, fn %{id: id} ->
             %{id: id, error: %{code: -32015, message: "VM execution error"}}
           end)}

        requests, _options when is_list(requests) ->
          {:ok, Enum.map(requests, fn %{id: id} -> %{id: id, result: "0x"} end)}

        %{id: id, method: "eth_blockNumber"}, _options ->
          {:ok, %{id: id, result: "0x1"}}

        request, _options when is_map(request) ->
          {:ok, %{id: Map.get(request, :id, 0), result: "0x"}}
      end)

      assert [] = Repo.all(Instance)

      start_supervised!({Indexer.Fetcher.TokenInstance.SanitizeERC1155, []})
      start_supervised!({Indexer.Fetcher.TokenInstance.Sanitize.Supervisor, [[flush_interval: 1]]})

      :timer.sleep(500)

      instances = Repo.all(Instance)

      assert Enum.count(instances) == 4
      assert Enum.all?(instances, fn instance -> !is_nil(instance.error) and is_nil(instance.metadata) end)
    end
  end
end
