class MeegoTestSessionSweeper < ActionController::Caching::Sweeper
  observe MeegoTestSession
  
  def after_save(test_session)
    expire_cache(test_session)
    expire_index_for(test_session)
  end
 
  private
   

  def expire_index_for(test_session)
    expire_page :controller => 'index', :action => :index
    expire_page :controller => 'upload', :action => :upload_form

    expire_paging_action :controller => "index", :action => "filtered_list", :release_version => test_session.release_version, :target => test_session.target, :testtype => test_session.testtype, :hwproduct => test_session.hwproduct
    expire_paging_action :controller => "index", :action => "filtered_list", :release_version => test_session.release_version, :target => test_session.target, :testtype => test_session.testtype
    expire_paging_action :controller => "index", :action => "filtered_list", :release_version => test_session.release_version, :target => test_session.target
  end

  def expire_fragments_for(test_session)
  	return if not test_session
    expire_fragment "preview_page_#{test_session.id}"
    expire_fragment "view_page_#{test_session.id}"
    expire_fragment "edit_page_#{test_session.id}"
    expire_fragment "print_page_#{test_session.id}"
  end

  def expire_cache(test_session)
    expire_fragments_for test_session

	prev_session = test_session.prev_session
	next_session = test_session.next_session

	expire_fragments_for prev_session
	expire_fragments_for next_session

	next_session = next_session.try(:next_session)
	expire_fragments_for next_session
  end

end