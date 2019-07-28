# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN  |   "" print EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "./Token.rb"
load "./Scanner.rb"
class Parser < Scanner
	$count = 0;
	def initialize(filename)
    	super(filename)
    	consume()
   	end

	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end

	def match(dtype)
      	if (@lookahead.type != dtype)
			 raise "Expected #{dtype} found #{@lookahead.type}"
			 $count = $count + 1;
      	end
      	consume()
   	end

	# "Might" need to modify this. Errors?
	def program()
      	while(@lookahead.type != Token::EOF)
        	puts "Entering STMT Rule"
			statement()	
		end
		if ($count == 0)
			puts "Program parsed with no errors."
		else
			puts "There were #{$count} parse errors found."
		end
   	end

	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			puts "Entering EXP Rule"
			exp()
		else
			puts "Entering ASSGN Rule"
			assign()
		end

		puts "Exiting STMT Rule"
	end

	def assign
		if (@lookahead.type == Token::ID)
			puts "Entering ID Rule"
			id();
		end

		if (@lookahead.type != Token::ASSGN)
				puts "Did not find ASSGN Token"	
			else
				puts "Found ASSGN Token: #{@lookahead.text}"	
				match(Token::ASSGN)
				puts "Entering EXP Rule"
				exp()	
		end

		puts "Exiting ASSGN Rule"
	end

	def id		
		if (@lookahead.type != Token::ID)
		    puts "Did not find ID Token"	
		else
			puts "Found ID Token: #{@lookahead.text}"	
			match(Token::ID)
			puts "Exiting ID Rule"	
		end
	end


	def exp
		puts "Entering TERM Rule"
		term()
		puts "Entering ETAIL Rule"
		etail()

		puts "Exiting EXP Rule"
	end
	
	# TERM       -->   FACTOR  TTAIL
	def term
		puts "Entering FACTOR Rule"
		factor()
		puts "Entering TTAIL Rule"
		ttail()
		puts "Exiting TERM Rule"
	end

	# FACTOR     -->   "(" EXP ")" | INT | ID
	def factor
		if (@lookahead.type == Token::LPAREN) 
			puts "Found LPAREN Token: #{@lookahead.text}"	
			match(Token::LPAREN)
			puts "Entering EXP Rule"
			exp()
			if (@lookahead.type == Token::RPAREN) 
				puts "Found RPAREN Token: #{@lookahead.text}"	
				match(Token::RPAREN)
			end	
		elsif (@lookahead.type == Token::INT)
			puts "Found INT Token: #{@lookahead.text}"	
			match(Token::INT)
		elsif (@lookahead.type == Token::ID)
			puts "Entering ID Rule"	
			id()
		else 
			puts "Did not find LPAREN or INT or ID Token"	
		end

		puts "Exiting FACTOR Rule"
	end


	# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
	def ttail 
		if (@lookahead.type == Token::MULTOP)
			puts "Found MULTOP Token: #{@lookahead.text}"	
			match(Token::MULTOP)
			puts "Entering FACTOR Rule"
			factor()
			puts "Entering TTAIL Rule"
			ttail()
		elsif (@lookahead.type == Token::DIVOP)
			puts "Found DIVOP Token: #{@lookahead.text}"	
			match(Token::DIVOP)
			puts "Entering FACTOR Rule"
			factor()
			puts "Entering TTAIL Rule"
			ttail()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"	
		end

		puts "Exiting TTAIL Rule"
		
	end

	# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
	def etail
		if (@lookahead.type == Token::ADDOP)
			puts "Found ADDOP Token: #{@lookahead.text}"	
			match(Token::ADDOP)
			puts "Entering TERM Rule"
			term()
			puts "Entering ETAIL Rule"
			etail()
		elsif (@lookahead.type == Token::SUBOP)
			puts "Found SUBOP Token: #{@lookahead.text}"	
			match(Token::SUBOP)
			puts "Entering TERM Rule"
			term()
			puts "Entering ETAIL Rule"
			etail()
		else
			puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"	
		end
	
		puts "Exiting ETAIL Rule"	
		
	end

end
