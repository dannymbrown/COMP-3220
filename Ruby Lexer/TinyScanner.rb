# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
#
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Class Scanner - Reads a TINY program and emits tokens
#
class Scanner

# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead
	def initialize(filename)
		if (File.exists?(filename))
    	@f = File.open(filename,'r:utf-8')
			if (! @f.eof?)
				# Go ahead and read in the first character in the source
				# code file (if there is one) so that you can begin
				# lexing the source code file
				@c = @f.getc()
			else
				@c = "!eof!"
				@f.close()
			end
		else
    	abort("ERROR: File Does Not Exist...Exiting")
		end
	end

	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "!eof!"
		end
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken()
		if @c == "!eof!"
			tok =Token.new(Token::EOF,"eof")
			return tok
		elsif (whitespace?(@c))
			str =""
			while whitespace?(@c)
				str += @c
				nextCh()
			end
			tok = Token.new(Token::WS, str)
			return tok;
		elsif letter?(@c)
			char = ""
			count = 0
			while letter?(@c)
				char += @c
				nextCh()
				count = count+1
			end
			if count == 1
				tok = Token.new(Token::ID, char)
			else
				tok = Token.new(Token::PRT, char)
			end
			return tok
		elsif numeric?(@c)
			num = @c
			tok = Token.new(Token::INT, num)
			nextCh()
			return tok
		elsif operator?(@c)
			if (@c =~ /^[=]$/)
				op = @c
				tok = Token.new(Token::ASSIGNOP, op)
				nextCh()
				return tok;
			elsif (@c =~ /^[(]$/)
				op = @c
				tok = Token.new(Token::LPAREN, op)
				nextCh()
				return tok;
			elsif (@c =~ /^[)]$/)
				op = @c
				tok = Token.new(Token::RPAREN, op)
				nextCh()
				return tok;
			elsif (@c =~ /^[+]$/)
				op = @c
				tok = Token.new(Token::ADDOP, op)
				nextCh()
				return tok;
			elsif (@c =~ /^[-]$/)
				op = @c
				tok = Token.new(Token::SUBOP, op)
				nextCh()
				return tok;
			elsif (@c =~ /^[*]$/)
				op = @c
				tok = Token.new(Token::MULOP, op)
				nextCh()
				return tok;
			elsif (@c =~ /^[#{Regexp.escape('/')}]$/)
				op = @c
				tok = Token.new(Token::DIVOP, op)
				nextCh()
				return tok;
			elsif (@c =~ /^[%]$/)
				op = @c
				tok = Token.new(Token::MODULO, op)
				nextCh()
				return tok
			end
		else
			tok = Token.new("unknown","unknown")
			nextCh()
			return tok;
		end
	end

#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end

def operator?(lookAhead)
	lookAhead =~  /^[=]|[+]|[*]|[(]|[)]|[-]|[%]|#{Regexp.escape('/')}$/
end

end

# End Of Class
