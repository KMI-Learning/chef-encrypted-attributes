#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/user'
require 'chef/encrypted_attribute/exceptions'

class Chef
  class EncryptedAttribute
    class RemoteUsers

      def self.get_public_keys(users=[])
        if users == '*'
          get_all_public_keys
        elsif users.kind_of?(Array)
          get_users_public_keys(users)
        elsif not users.nil?
          raise ArgumentError, "#{self.class.to_s}##{__method__} users argument must be an array or \"*\"."
        end
      end

      protected

      def self.get_user_public_key(name)
        begin
          user = Chef::User.load(name)
          user.public_key
        rescue Net::HTTPServerException => e
          case e.response.code
          when '403'
            raise NoAdminPrivileges, 'Your node needs admin privileges to be able to work with Chef Users.'
          when '404'
            raise UserNotFound, "Chef User not found: \"#{name}\"."
          else
            raise e
          end
        end
      end

      def self.get_users_public_keys(users)
        users.map { |n| get_user_public_key(n) }
      end

      def self.get_all_public_keys
        # Chef::User.list(inflate=true) has a bug
        get_users_public_keys(Chef::User.list.keys)
      end

    end
  end
end