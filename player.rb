class Player
	DANGER_HEALTH = 10
	MIN_HEALTH = 15
	MAX_LOOK = 4
	def play_turn(warrior)
		@last_health ||= warrior.health
		@took_damage = @last_health > warrior.health
		feeling warrior
		@last_health = warrior.health
	end
	private
	# If warrior should rest
	def should_rest?(warrior)
		!@took_damage && warrior.health < MIN_HEALTH
	end
	# if warrior should flee
	def should_flee?(warrior)
		bad_health = warrior.health < DANGER_HEALTH
		@took_damage && bad_health
	end
	def feeling(warrior)
		action(warrior, warrior.feel)
	end
	def action (warrior, space)
		my_enemies = enemies warrior
		my_captives = captives warrior
		if should_rest? warrior
			warrior.rest!
		elsif my_enemies.length >= 1
			if my_enemies.length >=2
				warrior.bind!(my_enemies.shift[0])
			else
				warrior.attack!(my_enemies.shift[0])
			end
		elsif should_rest? warrior
			p should_rest? warrior
			warrior.rest!
		elsif my_captives.length > 0
			warrior.rescue!(my_captives.shift[0])
		else
			warrior.walk!(warrior.direction_of_stairs)
		end
	end
	def enemies(warrior)
		@number ||= {};
		if @number.length ==0
			[:right, :left, :backward, :forward].each { | direction | @number[direction] = 1 if warrior.feel(direction).enemy? }
		end
		@number
	end
	def captives(warrior)
		@numberc ||= {};
		if @numberc.length ==0
			[:right, :left, :backward, :forward].each { | direction | @numberc[direction] = 1 if warrior.feel(direction).captive? }
		end
		@numberc
	end
end
