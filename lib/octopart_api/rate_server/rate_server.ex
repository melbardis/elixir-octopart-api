#
# Copyright (c) 2018 by Eric Melbardis @ Wyldewoods LLC.. All Rights Reserved.
#

defmodule OctopartApi.RateServer do
  @moduledoc """
  A GenServer template for a "singleton" process.
  """

  require Logger
  require HTTPoison

  use GenServer

  # Initialization
  def start_link(opts \\ []) do
    Logger.debug("start_link")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    state = %{
      # count of request in the current second
      count: 0,
      # max req/second
      max_count: 3,
      # que of waiting request, waiting till rate throtling is lifted
      que: [],
      # current request
      current: nil,
      # retry counter
      retry: 0,
      # rate interval
      time: 1_000
    }

    Process.send_after(self(), {:timeout, []}, state[:time])

    {:ok, state}
  end

  # API
  def get(query_string) do
    GenServer.call(__MODULE__, {:get, query_string})
  end

  # Callbacks

  @doc ~S"""
    Process a 'get' request.

    The request is enqued on the request que 'que:'.
  """
  def handle_call({req, query_string}, from, %{que: curQ} = state) do
    new_state =
      doRequest(%{state | que: List.insert_at(curQ, -1, %{req: req, from: from, q: query_string})})

    # we let doRequest return the appropriate reply to the caller.

    {:noreply, new_state}
  end

  def handle_cast({_, _}, state) do
    {:noreply, state}
  end

  def handle_info({:timeout, _}, state) do
    # Logger.debug("handle_info: :timeout")
    new_state = doRequest(state)
    Process.send_after(self(), {:timeout, []}, state[:time])
    {:noreply, %{new_state | count: 0}}
  end

  # Helpers

  defp doRequest(%{count: count, max_count: max_count, que: que} = state)
       when length(que) != 0 and count < max_count do
    # not rate limited, send frist request
    [%{req: req, from: from, q: q} | tail] = que
    response = HTTPoison.request(req, q)
    GenServer.reply(from, response)
    %{state | que: tail, count: count + 1}
  end

  defp doRequest(%{count: count, max_count: max_count, que: que} = state) do
    # wait time timeout event
    # Logger.debug(:io_lib.format("que maybe full ~w", [state]))
    state
  end
end
