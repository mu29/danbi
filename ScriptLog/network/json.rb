# filename network/json.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ JSON Encoder/Decoder
# --------------------------------------------------------------------------
# Author    Game Gay, Unicode
# Modify    뮤 (mu29gl@gmail.com)
# Date      2012. 6. 21
# --------------------------------------------------------------------------
# Description
# 
#    소수를 포함한 값이 들어가면 int로 정상 반환되지 않는 문제 해결
#    음수 값이 반환되지 않는 문제 해결
#────────────────────────────────────────────────────────────────────────────

module JSON
  TOKEN_NONE = 0
  TOKEN_CURLY_OPEN = 1
  TOKEN_CURLY_CLOSED = 2
  TOKEN_SQUARED_OPEN = 3
  TOKEN_SQUARED_CLOSED = 4
  TOKEN_COLON = 5
  TOKEN_COMMA = 6
  TOKEN_STRING = 7
  TOKEN_NUMBER = 8
  TOKEN_TRUE = 9
  TOKEN_FALSE = 10
  TOKEN_NULL = 11
  
  @index = 0
  @json = ""
  @length = 0
  
  def self.decode(json)
    @json = json
    @index = 0
    @length = @json.length
    return self.parse
  end
  
  def self.encode(obj)
    if obj.is_a?(Hash)
      return self.encode_hash(obj)
    elsif obj.is_a?(Array)
      return self.encode_array(obj)
    elsif obj.is_a?(Fixnum) || obj.is_a?(Float)
      return self.encode_integer(obj)
    elsif obj.is_a?(String)
      return self.encode_string(obj)
    elsif obj.is_a?(TrueClass) || obj.is_a?(FalseClass)
      return self.encode_bool(obj)
    elsif obj.is_a?(NilClass)
      return "null"
    end
    return nil
  end
  
  def self.encode_hash(hash)
    string = "{"
    hash.each_key {|key|
      string += "\"#{key}\":" + self.encode(hash[key]).to_s + ","
    }
    string[string.size - 1, 1] = "}"
    return string
  end
  
  def self.encode_array(array)
    string = "["
    array.each {|i|
      string += self.encode(i).to_s + ","
    }
    string[string.size - 1, 1] = "]"
    return string
  end
  
  def self.encode_string(string)
    return "\"#{string}\""
  end
  
  def self.encode_integer(int)
    return int.to_s
  end
  
  def self.encode_bool(bool)
    return (bool.is_a?(TrueClass) ? "true" : "false")
  end
  
  def self.next_token(debug = 0)
    char = @json[@index, 1]
    @index += 1
    case char
    when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-' 
      return TOKEN_NUMBER
    when '{' 
      return TOKEN_CURLY_OPEN
    when '}' 
      return TOKEN_CURLY_CLOSED
    when '"' 
      return TOKEN_STRING
    when ',' 
      return TOKEN_COMMA
    when '['
      return TOKEN_SQUARED_OPEN
    when ']'
      return TOKEN_SQUARED_CLOSED
    when ':' 
      return TOKEN_COLON
    end
    @index -= 1
    if @json[@index, 5] == "false"
      @index += 5
      return TOKEN_FALSE
    elsif @json[@index, 4] == "true"
      @index += 4
      return TOKEN_TRUE
    elsif @json[@index, 4] == "null"
      @index += 4
      return TOKEN_NULL
    end
    return TOKEN_NONE
  end
  
  def self.parse(debug = 0)
    complete = false
    while !complete
      if @index >= @length
        break
      end
      token = self.next_token
      case token
      when TOKEN_NONE
        return nil
      when TOKEN_NUMBER
        return self.parse_number
      when TOKEN_CURLY_OPEN
        return self.parse_object
      when TOKEN_STRING
        return self.parse_string
      when TOKEN_SQUARED_OPEN
        return self.parse_array
      when TOKEN_TRUE
        return true
      when TOKEN_FALSE
        return false
      when TOKEN_NULL
        return nil
      end
    end
  end
  
  def self.parse_object
    obj = {}
    complete = false
    while !complete
      token = self.next_token
      if token == TOKEN_CURLY_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        name = self.parse_string
        return nil if name == nil
        token = self.next_token
        return nil if token != TOKEN_COLON
        value = self.parse
        obj[name] = value
      end
    end
    return obj
  end
  
  def self.parse_string
    complete = false
    string = ""
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      case char
      when '"'
        complete = true
        break
      else
        string += char.to_s
      end
    end
    if !complete
      return nil
    end
    return string
  end
  
  def self.parse_number
    @index -= 1
    negative = @json[@index, 1] == "-" ? true : false
    string = ""
    complete = false
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      case char
      when "{", "}", ":", ",", "[", "]"
        @index -= 1
        complete = true
        break
      when "0", "1", "2", '3', '4', '5', '6', '7', '8', '9', '.'
        string += char.to_s
      end
    end
    number = string.to_i
    return negative ? -number : number
  end
  
  def self.parse_array
    obj = []
    complete = false
    while !complete
      token = self.next_token(1)
      if token == TOKEN_SQUARED_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        @index -= 1
        value = self.parse
        obj.push(value)
      end
    end
    return obj
  end
end
