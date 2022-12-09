defmodule Exwhisper.Element do
  use Membrane.Sink

  def_options(
    to_pid: [
      spec: :any,
      default: nil,
      description: "PID to report to"
    ]
  )

  def_input_pad(:input, demand_unit: :buffers, caps: :any)

  @impl true
  def handle_init(%__MODULE{to_pid: pid}) do
    state = %{accumulated: <<>>, to_pid: pid}

    {:ok, state}
  end

  @impl true
  def handle_prepared_to_playing(_ctx, state) do
    {{:ok, demand: :input}, state}
  end

  @impl true
  def handle_write(:input, buffer, ctx, state) do
    acc = [state.accumulated, buffer.payload]
    # IO.puts("Size: #{IO.iodata_length(acc)}")
    {{:ok, demand: :input}, %{state | accumulated: acc}}
  end

  @impl true
  def handle_prepared_to_stopped(_ctx, state) do
    IO.puts("Ending memory sink, sending to recipient: #{inspect(state.to_pid)}")
    send(state.to_pid, {:buffer, IO.iodata_to_binary(state.accumulated)})
    {:ok, state}
  end
end
