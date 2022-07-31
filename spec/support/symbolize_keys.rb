class Hash
  def symbolize_keys
    self.reduce({}) do |pre, pair|
      old_key, old_val = pair

      key = old_key.respond_to?(:to_sym) ? old_key.to_sym : old_key
      val = old_val.respond_to?(:symbolize_keys) ? old_val.symbolize_keys : old_val

      pre[key] = val
      pre
    end
  end
end
