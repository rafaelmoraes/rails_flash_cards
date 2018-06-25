class RootRouteTest < ActionDispatch::IntegrationTest
  test 'should open the sign_in page' do
    assert_routing '/', controller: 'devise/sessions', action: 'new'
  end
end
