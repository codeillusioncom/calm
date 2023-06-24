class TableView < Calm::Http::BaseView
  def index(context, args)
    context.ui do
      h1 "Table"
    end
  end
end
