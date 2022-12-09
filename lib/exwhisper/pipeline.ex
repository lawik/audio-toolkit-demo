defmodule Exwhisper.Pipeline do
  use Membrane.Pipeline

  @target_sample_rate 16000

  @impl true
  def handle_init(opts) do
    IO.inspect(opts, label: "opts")
    input = Keyword.fetch!(opts, :input)
    to_pid = Keyword.fetch!(opts, :to_pid)

    children = %{
      file: %Membrane.File.Source{location: input},
      decoder: Membrane.MP3.MAD.Decoder,
      converter: %Membrane.FFmpeg.SWResample.Converter{
        output_caps: %Membrane.RawAudio{
          sample_format: :s16le,
          sample_rate: @target_sample_rate,
          channels: 1
        }
      },
      memory: %Exwhisper.Element{to_pid: to_pid}
      # file_out: %Membrane.File.Sink{location: "/tmp/file.wav"}
    }

    links = [
      # link(:file) |> to(:decoder) |> to(:converter) |> to(:file_out)
      link(:file) |> to(:decoder) |> to(:converter) |> to(:memory)
    ]

    {{:ok, spec: %ParentSpec{children: children, links: links}, playback: :playing}, %{}}
  end

  @impl true
  def handle_shutdown(reason, state) do
    IO.inspect(state)
    IO.inspect("Shutdown: #{inspect(reason)}")
    :ok
  end

  @impl true
  def handle_notification(notification, element, context, state) do
    IO.inspect(notification, label: "notification")
    IO.inspect(element, label: "element")
    {:ok, state}
  end

  @impl true
  def handle_element_end_of_stream({:file_out, :input}, context, state) do
    IO.puts("file sink complete")
    {{:ok, playback: :stopped}, state}
  end

  @impl true
  def handle_element_end_of_stream({:memory, :input}, context, state) do
    IO.puts("memory sink complete")
    {{:ok, playback: :stopped}, state}
  end

  @impl true
  def handle_element_end_of_stream(_, _context, state) do
    {:ok, state}
  end

  def handle_prepared_to_stopped(_context, state) do
    IO.puts("terminating pipeline")
    terminate(self())
    {:ok, state}
  end
end
