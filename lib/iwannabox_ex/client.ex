defmodule IwannaboxEx.Client do

  def account() do
    _get("/account")
  end

  def image_types() do
    _get("/image_types")
  end

  def image_types(params) do
    _get("/image_types?" <> URI.encode_query(params))
  end

  def regions() do
    _get("/regions")
  end

  def regions(params) do
    _get("/regions?" <> URI.encode_query(params))
  end

  def sizes() do
    _get("/sizes")
  end

  def sizes(params) do
    _get("/sizes?" <> URI.encode_query(params))
  end

  def find(params) do
    _get("/find?" <> URI.encode_query(params))
  end

  def environments() do
    _get("/definitions")
  end

  def environments(params) do
    _get("/definitions/?" <> URI.encode_query(params))
  end

  def create_environment(name) do
    params = %{ name: name, file_type: "blank" }
    _post("/definitions", params)
  end

  def create_environment(name, file_type) do
    params = %{ name: name, file_type: file_type }
    _post("/definitions", params)
  end

  def environment(environment) do
    _get("/definitions/#{environment |> _id}")
  end

  def destroy_environment(environment) do
    _delete("/definitions/#{environment |> _id}")
  end

  def boxes(environment) do
    _get("/definitions/#{environment |> _id}/boxes")
  end

  def create_box(environment, %{ "region" => _region, "sizing" => _sizing, "dist" => _dist } = box_def) do
    _post("/definitions/#{environment |> _id}/boxes", box_def)
  end

  def create_box(environment, params) do
    box =  %{
      region: Map.take(params, [:provider, :continent, :region, :country, :city]),
      sizing: Map.take(params, [:provider, :vcpus, :disk, :gb]),
      dist: Map.take(params, [:provider, :name, :distribution, :slug])
    }

    _post("/definitions/#{environment |> _id}/boxes", box)
  end

  def destroy_box(box) do
    _delete("/boxes/#{_id(box)}")
  end

  def instances do
    _get("/instances")
  end

  def instances(box) do
    _get("/boxes/#{_id(box)}/instances")
  end

  def create_instance(box, instance) do
    _post("/boxes/#{_id(box)}/instances", instance)
  end

  def instance_status(instance) do
    _get("/instances/#{_id(instance)}")
  end

  def destroy_instance(instance) do
    _delete("/instances/#{_id(instance)}")
  end

  def start_instance(instance) do
    _put("/instances/#{_id(instance)}/start")
  end

  def stop_instance(instance) do
    _put("/instances/#{_id(instance)}/stop")
  end

  def reboot_instance(instance) do
    _put("/instances/#{_id(instance)}/reboot")
  end

  def snapshot_instance(instance) do
    _post("/instances/#{_id(instance)}/snapshot")
  end

  defp _id(%{"id" => id}) do
    id
  end

  defp _id(%{:id => id}) do
    id
  end

  defp _id(id) when is_integer(id) do
    id
  end

  defp _get(path) do
    HTTPoison.request(:get, _iwb_url(path), "",  _headers(), _options())
    |> _handle_result
  end

  defp _post(path) do
    HTTPoison.request(:post, _iwb_url(path), "",  _headers(), _options())
    |> _handle_result
  end

  defp _post(path, params) do
    HTTPoison.request(:post, _iwb_url(path), params |> Poison.encode!(),  _headers(), _options())
    |> _handle_result
  end

  defp _put(path) do
    HTTPoison.request(:post, _iwb_url(path), "",  _headers(), _options())
    |> _handle_result
  end

  defp _delete(path) do
    HTTPoison.request(:delete, _iwb_url(path), "",  _headers(), _options())
    |> _handle_result
  end

  defp _options() do
    Application.get_env(:iwannabox_ex, :http_options, [])
  end

  defp _headers() do
    [{"Content-type", "application/json"},
               {"Authorization",
                "Bearer #{Application.get_env(:iwannabox_ex, :api_key)}"}]
  end

  defp _handle_result({:ok, %{:status_code => 200, :body => nil} = result} ) do
    {:ok, result}
  end

  defp _handle_result({:ok, %{:status_code => 200} = result} ) do
    {:ok, result.body |> Poison.decode!}
  end

  defp _handle_result({:ok, result} ) do
    {:error, result}
  end

  defp _iwb_base_url() do
    Application.get_env(:iwannabox_ex, :url_base, "https://iwannabox.com/api/v1")
  end

  defp _iwb_url(endpoint) do
    _iwb_base_url() <> endpoint
  end
end
