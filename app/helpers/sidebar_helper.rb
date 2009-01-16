module SidebarHelper
  def sidebar_block(title, options = {}, &block)
    title.downcase!
    @sidebar_blocks ||= []
    
    Struct.new("SidebarBlock", :title, :contents, :styles)
    blk = Struct::SidebarBlock.new(title, capture(&block), options)
    @sidebar_blocks << blk
  end
end