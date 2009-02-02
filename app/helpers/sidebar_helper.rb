module SidebarHelper
  def sidebar_block(title, options = {}, &block)
    title.downcase!
    @sidebar_blocks ||= []
    
    options[:class] ||= ''
    options[:class] += title.gsub(/[^a-z]/, ' ').strip.gsub(/\s+/, '_')
    
    Struct.new("SidebarBlock", :title, :contents, :styles)
    @sidebar_blocks << Struct::SidebarBlock.new(title, capture(&block), options)
  end
end