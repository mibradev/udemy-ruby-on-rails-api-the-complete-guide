module Serializeable
  private
    def serializer_links(records)
      path = "#{controller_name}_path"

      {
        self: send(path, page: records.current_page, per_page: params[:per_page]),
        first: send(path, per_page: params[:per_page]),
        next: !records.next_page ? nil : send(path, page: records.next_page, per_page: params[:per_page]),
        previous: !records.prev_page ? nil : send(path, page: records.prev_page, per_page: params[:per_page]),
        last: send(path, page: records.total_pages, per_page: params[:per_page])
      }
    end
end
