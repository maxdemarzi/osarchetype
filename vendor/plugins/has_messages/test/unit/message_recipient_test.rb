require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class MessageRecipientByDefaultTest < ActiveSupport::TestCase
  def setup
    @recipient = MessageRecipient.new
  end
  
  def test_should_not_have_a_message
    assert_nil @recipient.message_id
  end
  
  def test_should_not_have_a_receiver_id
    assert_nil @recipient.receiver_id
  end 
  
  def test_should_not_have_a_receiver_type
    assert @recipient.receiver_type.blank?
  end
  
  def test_should_not_have_a_kind
    assert @recipient.kind.blank?
  end
  
  def test_should_not_have_a_position
    assert_nil @recipient.position
  end
  
  def test_should_be_in_the_unread_state
    assert_equal 'unread', @recipient.state
  end
  
  def test_should_not_be_hidden
    assert_nil @recipient.hidden_at
    assert !@recipient.hidden?
  end
end

class MesageRecipientTest < ActiveSupport::TestCase
  def test_should_be_valid_with_a_set_of_valid_attributes
    recipient = new_message_recipient
    assert recipient.valid?
  end
  
  def test_should_require_a_message
    recipient = new_message_recipient(:message => nil)
    assert !recipient.valid?
    assert recipient.errors.invalid?(:message_id)
  end
  
  def test_should_require_a_kind
    recipient = new_message_recipient(:kind => nil)
    assert !recipient.valid?
    assert recipient.errors.invalid?(:kind)
  end
  
  def test_should_require_a_state
    recipient = new_message_recipient(:state => nil)
    assert !recipient.valid?
    assert recipient.errors.invalid?(:state)
  end
  
  def test_should_require_a_receiver_id
    recipient = new_message_recipient(:receiver => nil)
    assert !recipient.valid?
    assert recipient.errors.invalid?(:receiver_id)
  end
  
  def test_should_require_a_receiver_type
    recipient = new_message_recipient(:receiver => nil)
    assert !recipient.valid?
    assert recipient.errors.invalid?(:receiver_type)
  end
  
  def test_should_not_require_a_position
    recipient = new_message_recipient(:position => nil)
    assert recipient.valid?
  end
  
  def test_should_protect_attributes_from_mass_assignment
    recipient = MessageRecipient.new(
      :id => 1,
      :message_id => 1,
      :receiver_id => 1,
      :receiver_type => 'User',
      :kind => 'bcc',
      :position => 10,
      :state => 'read',
      :hidden_at => Time.now
    )
    
    assert_nil recipient.id
    assert_equal 1, recipient.message_id
    assert_equal 1, recipient.receiver_id
    assert_equal 'User', recipient.receiver_type
    assert_equal 'bcc', recipient.kind
    assert_nil recipient.position
    assert_equal 'unread', recipient.state
    assert_nil recipient.hidden_at
  end
end

class MessageRecipientAfterBeingCreatedTest < ActiveSupport::TestCase
  def setup
    @admin = create_user(:login => 'admin')
    @erich = create_user(:login => 'Erich')
    @richard = create_user(:login => 'Richard')
    @ralph = create_user(:login => 'Ralph')
    
    message = create_message(
      :subject => 'Hello',
      :body => 'How are you?',
      :sender => @admin,
      :cc => @richard,
      :bcc => @ralph
    )
    @recipient = create_message_recipient(
      :message => message,
      :receiver => @erich,
      :kind => 'to'
    )
  end
  
  def test_should_not_be_hidden
    assert !@recipient.hidden?
  end
  
  def test_should_delegate_sender_to_message
    assert_equal @admin, @recipient.sender
  end
  
  def test_should_delegate_subject_to_message
    assert_equal 'Hello', @recipient.subject
  end
  
  def test_should_delegate_body_to_message
    assert_equal 'How are you?', @recipient.body
  end
  
  def test_should_delegate_recipients_to_message
    assert_equal [@erich, @richard, @ralph], @recipient.recipients.map(&:receiver)
  end
  
  def test_should_delegate_to_receivers_to_message
    assert_equal [@erich], @recipient.to
  end
  
  def test_should_delegate_cc_receivers_to_message
    assert_equal [@richard], @recipient.cc
  end
  
  def test_should_delegate_bcc_receivers_to_message
    assert_equal [@ralph], @recipient.bcc
  end
  
  def test_should_delegate_created_at_to_message
    assert_not_nil @recipient.created_at
  end
end

class MessageRecipientOfMultipleTest < ActiveSupport::TestCase
  def setup
    @erich = create_user(:login => 'Erich')
    @richard = create_user(:login => 'Richard')
    @ralph = create_user(:login => 'Ralph')
    
    message = create_message(:to => [@erich, @richard])
    @recipient = create_message_recipient(
      :message => message,
      :receiver => @ralph,
      :kind => 'to'
    )
  end
  
  def test_should_use_position_based_on_position_of_last_recipient
    assert_equal 3, @recipient.position
  end
end

class MessageRecipientUnreadWithUnsentMessageTest < ActiveSupport::TestCase
  def setup
    @recipient = create_message_recipient
  end
  
  def test_should_be_in_the_unread_state
    assert_equal 'unread', @recipient.state
  end
  
  def test_should_not_be_able_to_view
    assert !@recipient.view
  end
end

class MessageRecipientUnreadWithSentMessageTest < ActiveSupport::TestCase
  def setup
    @recipient = create_message_recipient
    @recipient.message.deliver
  end
  
  def test_should_be_in_the_unread_state
    assert_equal 'unread', @recipient.state
  end
  
  def test_should_be_able_to_view
    assert @recipient.view
  end
end

class MessageRecipientReadTest < ActiveSupport::TestCase
  def setup
    @recipient = create_message_recipient
    @recipient.message.deliver
    @recipient.view
  end
  
  def test_should_be_in_the_read_state
    assert_equal 'read', @recipient.state
  end
  
  def test_should_not_be_able_to_view
    assert !@recipient.view
  end
end

class MessageRecipientHiddenTest < ActiveSupport::TestCase
  def setup
    @recipient = create_message_recipient
    @recipient.hide
  end
  
  def test_should_record_when_it_was_hidden
    assert_not_nil @recipient.hidden_at
  end
  
  def test_should_be_hidden
    assert @recipient.hidden?
  end
  
  def test_should_not_be_visible
    assert !@recipient.visible?
  end
end

class MessageRecipientUnhiddenTest < ActiveSupport::TestCase
  def setup
    @recipient = create_message_recipient
    @recipient.hide
    @recipient.unhide
  end
  
  def test_should_not_have_the_recorded_value_when_it_was_hidden
    assert_nil @recipient.hidden_at
  end
  
  def test_should_not_be_hidden
    assert !@recipient.hidden?
  end
  
  def test_should_be_visible
    assert @recipient.visible?
  end
end

class MessageRecipientForwardedTest < ActiveSupport::TestCase
  def setup
    @erich = create_user(:login => 'Erich')
    original_message = create_message(
      :subject => 'Hello',
      :body => 'How are you?',
      :cc => create_user(:login => 'Richard'),
      :bcc => create_user(:login => 'Ralph')
    )
    @recipient = create_message_recipient(
      :message => original_message,
      :receiver => @erich
    )
    @message = @recipient.forward
  end
  
  def test_should_be_in_unsent_state
    assert_equal 'unsent', @message.state
  end
  
  def test_should_not_be_hidden
    assert !@message.hidden?
  end
  
  def test_should_have_original_subject
    assert_equal 'Hello', @message.subject
  end
  
  def test_should_have_original_body
    assert_equal 'How are you?', @message.body
  end
  
  def test_should_use_receiver_as_the_sender
    assert_equal @erich, @message.sender
  end
  
  def test_should_not_include_to_recipients
    assert @message.to.empty?
  end
  
  def test_should_not_include_cc_recipients
    assert @message.cc.empty?
  end
  
  def test_should_not_include_bcc_recipients
    assert @message.bcc.empty?
  end
end

class MessageRecipientRepliedTest < ActiveSupport::TestCase
  def setup
    @erich = create_user(:login => 'Erich')
    @john = create_user(:login => 'John')
    original_message = create_message(
      :subject => 'Hello',
      :body => 'How are you?',
      :to => @john,
      :cc => create_user(:login => 'Richard'),
      :bcc => create_user(:login => 'Ralph')
    )
    @recipient = create_message_recipient(
      :message => original_message,
      :receiver => @erich
    )
    @message = @recipient.reply
  end
  
  def test_should_be_in_unsent_state
    assert_equal 'unsent', @message.state
  end
  
  def test_should_not_be_hidden
    assert !@message.hidden?
  end
  
  def test_should_have_original_subject
    assert_equal 'Hello', @message.subject
  end
  
  def test_should_have_original_body
    assert_equal 'How are you?', @message.body
  end
  
  def test_should_use_receiver_as_the_sender
    assert_equal @erich, @message.sender
  end
  
  def test_should_include_to_recipients
    assert [@erich, @john], @message.to
  end
  
  def test_should_not_include_cc_recipients
    assert @message.cc.empty?
  end
  
  def test_should_not_include_bcc_recipients
    assert @message.bcc.empty?
  end
end

class MessageRecipientRepliedToAllTest < ActiveSupport::TestCase
  def setup
    @erich = create_user(:login => 'Erich')
    @john = create_user(:login => 'John')
    @richard = create_user(:login => 'Richard')
    @ralph = create_user(:login => 'Ralph')
    original_message = create_message(
      :subject => 'Hello',
      :body => 'How are you?',
      :to => @john,
      :cc => @richard,
      :bcc => @ralph
    )
    @recipient = create_message_recipient(
      :message => original_message,
      :receiver => @erich
    )
    @message = @recipient.reply_to_all
  end
  
  def test_should_be_in_unsent_state
    assert_equal 'unsent', @message.state
  end
  
  def test_should_not_be_hidden
    assert !@message.hidden?
  end
  
  def test_should_have_original_subject
    assert_equal 'Hello', @message.subject
  end
  
  def test_should_have_original_body
    assert_equal 'How are you?', @message.body
  end
  
  def test_should_use_receiver_as_the_sender
    assert_equal @erich, @message.sender
  end
  
  def test_should_include_to_recipients
    assert [@erich, @john], @message.to
  end
  
  def test_should_include_cc_recipients
    assert_equal [@richard], @message.cc
  end
  
  def test_should_include_bcc_recipients
    assert_equal [@ralph], @message.bcc
  end
end

class MessageRecipientAfterBeingDestroyedTest < ActiveSupport::TestCase
  def setup
    message = create_message
    @first_recipient = create_message_recipient(
      :message => message,
      :receiver => create_user(:login => 'Erich'),
      :kind => 'to'
    )
    @last_recipient = create_message_recipient(
      :message => message,
      :receiver => create_user(:login => 'Richard'),
      :kind => 'to'
    )
    
    assert @first_recipient.destroy
    @last_recipient.reload
  end
  
  def test_should_reorder_positions_of_all_other_recipients
    assert_equal 1, @last_recipient.position
  end
end

class MessageRecipientAsAClassTest < ActiveSupport::TestCase
  def setup
    message = create_message
    @hidden_recipient = create_message_recipient(:message => message, :receiver => create_user(:login => 'erich'), :hidden_at => Time.now)
    @visible_recipient = create_message_recipient(:message => message, :receiver => create_user(:login => 'richard'))
  end
  
  def test_should_include_only_visible_messages_in_visible_scope
    assert_equal [@visible_recipient], MessageRecipient.visible
  end
end
