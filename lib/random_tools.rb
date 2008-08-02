class RandomTools
  def self.random_number_string( length )
    rand( ( "9" * length ).to_i ).to_s.center( length, rand(9).to_s ) 
  end
end