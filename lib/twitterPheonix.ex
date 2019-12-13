defmodule TwitterPheonix do
  @moduledoc """
  TwitterPheonix keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  #TwitterPheonixWeb.Twitter.twitterStart(100,10)
  IO.inspect "starting here right"
  #engine = TwitterPheonixWeb.Twitter.Engine.start_node()

  #engineId = %Engine.Engine{engineId: engine}
  #Engine.Repo.insert(engineId)

  IO.inspect "inserted into repository"

  #:ets.new(:engineTable, [:named_table,:public])
  #:ets.insert_new(:engineTable, {"engineId", engine})
  IO.inspect :engineTable, label: "created_newly"

  IO.inspect "Testing Engine"
  #Trial.testingEngine()

  def getEngineId() do
      IO.inspect "goooo"
      IO.inspect "got engines"
      #IO.inspect :ets.whereis(:engineTable), label: "engineTable"
      #IO.inspect :ets.whereis(:users), label: "usersgot"

    #[{ _ , engine}] = :ets.lookup(:engineTable, "engineId")
  end

end
