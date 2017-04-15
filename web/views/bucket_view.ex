defmodule Blaces.BucketView do
  use Blaces.Web, :view

  def render("index.json", %{buckets: buckets}) do
    %{data: render_many(buckets, Blaces.BucketView, "bucket.json")}
  end

  def render("bucket.json", %{bucket: bucket}) do
    %{id: bucket.id,
      name: bucket.name,
      short_name: bucket.short_name,
      is_public: bucket.is_public}
  end

end
