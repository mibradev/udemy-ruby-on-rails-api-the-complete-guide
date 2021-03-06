module Serializeable
  def serialize(records, **options)
    Rails.application.routes.router.recognize(request) do |route, matches, parameters|
      path = "#{route.name}_path"

      options[:links] ||= {
        self: send(path, page: records.current_page, per_page: params[:per_page]),
        first: send(path, per_page: params[:per_page]),
        next: !records.next_page ? nil : send(path, page: records.next_page, per_page: params[:per_page]),
        previous: !records.prev_page ? nil : send(path, page: records.prev_page, per_page: params[:per_page]),
        last: send(path, page: records.total_pages, per_page: params[:per_page])
      } if records.respond_to?(:per)
    end

    serializer = options[:serializer] || controller_name
    "#{serializer.to_s.classify}Serializer".constantize.new(records, options)
  end

  def serialize_errors(record)
    {
      errors: record.errors.messages.map do |k, v|
        v.map do |m|
          {
            source: { pointer: "/data/attributes/#{k}" },
            detail: m
          }
        end
      end.flatten
    }
  end
end
