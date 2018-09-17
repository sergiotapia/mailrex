# defmodule Mailrex.EmailProcessor do
#   use GenServer

#   def start_link do
#     GenServer.start_link(
#       __MODULE__,
#       Mailrex.Mailer.unsent_emails(),
#       name: __MODULE__
#     )
#   end

#   def queue(message) do
#     GenServer.cast(__MODULE__, {:queue, message})
#   end

#   def init(messages) do
#     queue = :queue.from_list(messages)
#     schedule_queue_processing()
#     {:ok, queue}
#   end

#   def handle_cast({:queue, message}, queue) do
#     {:noreply, :queue.in(message, queue)}
#   end

#   def handle_info(:process_queue, queue) do
#     queue = process_queue(queue)
#     schedule_queue_processing()
#     {:noreply, queue}
#   end

#   def process_queue(queue) do
#     case :queue.out(queue) do
#       {{:value, email}, queue} ->
#         email =
#           email
#           |> Mailrex.Mailer.send_email(email)

#         Mailrex.Mailer.remove_from_queue(email)

#         queue

#       {:empty, queue} ->
#         queue
#     end
#   end

#   defp schedule_queue_processing do
#     Process.send_after(self(), :process_queue, 500)
#   end
# end
