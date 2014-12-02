module Infuseit
  class Contact < Base

    define_schema :first_name, :middle_name, :nickname, :last_name, :suffix, :title,
      :company_id, :job_title, :assistant_name, :assistant_phone,
      :contact_notes, :contact_type,
      :date_created, :referral_code, :spouse_name, :username, :website

    define_collection :email
    define_collection :phone
    define_collection :fax
    define_collection :address

    def company
      # !!!! IMPLEMENT this
    end

    # Adds the contact to a follow-up sequence (campaigns were the original name of follow-up sequences).
    #
    # @param [Integer] campaign_id
    # @return [Boolean] returns true/false if the contact was added to the follow-up sequence
    #   successfully
    def add_to_campaign campaign_id
      get('ContactService.addToCampaign', id, campaign_id)
    end

    # Returns the Id number of the next follow-up sequence step for the contact.
    #
    # @param [Integer] campaign_id
    # @return [Integer] id number of the next unfishished step in the given follow up sequence
    #   for the given contact
    def next_campaign_step campaign_id
      get('ContactService.getNextCampaignStep', id, campaign_id)
    end

    # Pauses a follow-up sequence for the contact
    #
    # @param [Integer] campaign_id
    # @return [Boolean] returns true/false if the sequence was paused
    def pause_campaign campaign_id
      get('ContactService.pauseCampaign', id, campaign_id)
    end

    # Removes a follow-up sequence from the contact
    #
    # @param [Integer] campaign_id
    # @return [Boolean] returns true/false if removed
    def remove_from_campaign campaign_id
      get('ContactService.removeFromCampaign', id, campaign_id)
    end

    # Resumes a follow-up sequence that has been stopped/paused for the contact
    #
    # @param [Ingeger] campaign_id
    # @return [Boolean] returns true/false if sequence was resumed
    def resume_campaign campaign_id
      get('ConactService.resumeCampaignForContact', id, campaign_id)
    end

    # Removes a tag from the contact (groups were the original name of tags).
    #
    # @param [Integer] group_id
    # @return [Boolean] returns true/false if tag was removed successfully
    def remove_from_group group_id
      get('ContactService.removeFromGroup', id, group_id)
    end

    # Adds a tag to the contact
    #
    # @param [Integer] group_id
    # @return [Boolean] returns true/false if the tag was added successfully
    def add_to_group group_id
      get('ContactService.addToGroup', id, group_id)
    end

    # Runs an action set on the contact record
    #
    # @param [Integer] action_set_id
    # @return [Array<Hash>] A list of details on each action run
    # @example here is a list of what you get back
    #   [{ 'Action' => 'Create Task', 'Message' => 'task1 (Task) sent successfully', 'isError' =>
    #   nil }]
    def run_action_set action_set_id
      get('ContactService.runActionSequence', id, action_set_id)
    end

    # Creates a new recurring order for the contact.
    #
    # @param [Boolean] allow_duplicate
    # @param [Integer] cprogram_id
    # @param [Integer] merchant_account_id
    # @param [Integer] credit_card_id
    # @param [Integer] affiliate_id
    def add_recurring_order(allow_duplicate, cprogram_id, merchant_account_id,
                                    credit_card_id, affiliate_id, days_till_charge)
      response = get('ContactService.addRecurringOrder', id, allow_duplicate, cprogram_id,
                          merchant_account_id, credit_card_id, affiliate_id, days_till_charge)
    end

    # Executes an action sequence for the contact, passing in runtime params
    # for running affiliate signup actions, etc
    #
    # @param [Integer] action_set_id
    # @param [Hash] data
    def run_action_set_with_params(action_set_id, data)
      response = get('ContactService.runActionSequence', id, action_set_id, data)
    end


    private

    def add options = {}
      dedup_type = options.delete('DuplicationCheck') { 'EmailAndName' }

      @id = if dedup_type
        get('ContactService.addWithDupCheck', data, dedup_type)
      else
        get('ContactService.add', data)
      end
    end

  end
end
