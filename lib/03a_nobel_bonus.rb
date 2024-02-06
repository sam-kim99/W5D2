# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

# BONUS PROBLEM: Requires sub-queries or joins. Do NOT attempt this problem
# until you have completed all SQL Zoo problems in the regular (i.e., non-bonus)
# files.

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
  SQL
end
