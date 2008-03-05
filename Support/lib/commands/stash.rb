require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'

class SCM::Git::Stash < SCM::Git::SubmoduleBase
  def list
    base.command("stash", "list").split("\n").map do |line|
      /^(.+?):(.+)$/.match(line)
      name = $1
      description = $2
      /([0-9]+)/.match(name)
      {:id => $1.to_i, :name => name, :description => description}
    end
  end
  
  def save(desciption = "")
    params = []
    params << desciption unless desciption.nil? || desciption.empty?
    base.command("stash", "save", *params)
  end
  
  def diff(name)
    base.parse_diff(base.command("stash", "show", "-p", name))
  end
  
  def apply(name)
    base.command("stash", "apply", "--index", name)
  end
  
  def clear
    base.command("stash", "clear")
  end
end