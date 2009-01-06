module SidebarHelper
  def sidebar_block(title, &block)
    logger.info("Adding :#{title} to sidebar")
    
    title.downcase!
    @sidebar_blocks ||= ActiveSupport::OrderedHash.new
    @sidebar_blocks[title] ||= []
    @sidebar_blocks[title] << capture(&block)
  end
end