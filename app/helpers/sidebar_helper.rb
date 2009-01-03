module SidebarHelper
  def sidebar_block(title, &block)
    title.downcase!
    @sidebar_blocks ||= {}
    @sidebar_blocks[title] ||= []
    @sidebar_blocks[title] << capture(&block)
  end
end