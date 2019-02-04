#encoding:utf-8

module Deepspace

# 2.3.17 - Translation from Java
# @author Profesor
    
class CardDeck 
  
  def initialize()
    @cards=Array.new()
    @ready=false
    @count=0
  end
  
  public
  
  def add (t)
    if !@ready then
      @cards << t
    end
  end
  
  def next ()
    if (!@ready) then
      @ready=true;
      shuffle();
    end
      
    card=@cards.delete_at(0);
    @cards.push(card);
    
    @count+=1
    if (@count==@cards.size()) then
      shuffle();
      @count=0;
    end
      
    return card.class.newCopy(card)
  end
  
  def justShuffled()
    return (@count==0)
  end

  private
  
  def shuffle()
    @cards.shuffle!
  end
  
  def to_s
    getUIversion().to_s
  end
  
end # class

end # module

if $0 == __FILE__ then
  class TestCard
    attr_reader :a
    def initialize (a)
      @a=a
    end
  end
  
  test=Deepspace::CardDeck.new
  test.add(TestCard.new(1))
  test.add(TestCard.new(2))
  test.add(TestCard.new(3))
  test.add(TestCard.new(4))
  test.add(TestCard.new(5))
  for i in 0..15 do
    puts test.next.a
  end
end
