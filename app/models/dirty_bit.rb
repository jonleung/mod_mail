class DirtyBit
	def self.r
		@@r ||= Nest.new(self.class.to_s.underscore)
	end

	def initialize
		@r = DirtyBit.r
		@key = generate_key
		@r[@key].set("false")
	end

	def generate_key
		begin
			random_token = SecureRandom.urlsafe_base64
			return random_token unless @r[random_token].get.present?
		end
	end

	def self.make_dirty(key)
		raise "DirtyBit key #{key} not found." unless self.r[key].get.present?
		self.r[key].set("true")
	end

	def self.find_by_key(key)
		raise "DirtyBit key #{key} not found." unless self.r[key].get.present?
		status = self.r[key].get
		return true if status == "true"
		return false
	end

	def is_dirty?
		status = @r[@key].get
		return true if status == "true"
		return false
	end

end