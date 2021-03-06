## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at https://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is Pivotal Software, Inc.
## Copyright (c) 2016-2020 VMware, Inc. or its affiliates.  All rights reserved.

defmodule RabbitMQ.CLI.Ctl.Commands.CancelSyncQueueCommand do
  alias RabbitMQ.CLI.Core.DocGuide

  @behaviour RabbitMQ.CLI.CommandBehaviour
  use RabbitMQ.CLI.DefaultOutput

  def merge_defaults(args, opts) do
    {args, Map.merge(%{vhost: "/"}, opts)}
  end

  use RabbitMQ.CLI.Core.AcceptsOnePositionalArgument

  use RabbitMQ.CLI.Core.RequiresRabbitAppRunning

  def run([queue], %{vhost: vhost, node: node_name}) do
    :rpc.call(
      node_name,
      :rabbit_mirror_queue_misc,
      :cancel_sync_queue,
      [:rabbit_misc.r(vhost, :queue, queue)],
      :infinity
    )
  end

  def usage, do: "cancel_sync_queue [--vhost <vhost>] <queue>"

  def usage_additional() do
    [
      ["<queue>", "Queue name"]
    ]
  end

  def usage_doc_guides() do
    [
      DocGuide.mirroring()
    ]
  end

  def help_section(), do: :replication

  def description(), do: "Instructs a synchronising mirrored queue to stop synchronising itself"

  def banner([queue], %{vhost: vhost, node: _node}) do
    "Stopping synchronising queue '#{queue}' in vhost '#{vhost}' ..."
  end
end
