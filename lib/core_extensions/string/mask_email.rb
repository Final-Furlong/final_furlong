module CoreExtensions
  module String
    module MaskEmail
      def mask_email
        account_name_length = rpartition("@").first.size
        tld = rpartition("@").last.rpartition(".").last
        domain_name_length = rpartition("@").last.rpartition(".").first.size

        "#{'*' * account_name_length}@#{'*' * domain_name_length}.#{tld}"
      end
    end
  end
end
