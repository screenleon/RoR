class PostsController < ApplicationController
  def index
    #render html: "hello workd"
    @posts = Array.new
    #row={};
    begin
      File.open("post.txt", "r") do |f|
        f.each_line do |line|
          row={}
          splited = line.split("\t")
          row[:timestamp] = splited[0]
          row[:email] = splited[1]
          row[:nickname] = splited[2]
          row[:posttext] = splited[3]
          @posts.push(row)
        end
      end
    rescue => e
      row[:nickname]="No post yet. Leave some message to me? ;-)"
      @posts.push(row)
      #print_exception(e, true)
    end
  end

  def add
    @rec = Time.now.to_time.to_i.to_s+"\t"+params[:email]+"\t"+params[:nickname]+"\t"+params[:posttext]
    open('post.txt', 'a'){|f|
      f.puts @rec
    }
  end

  def show
    @post = {}
    File.open("post.txt", "r") do |f|
      f.each_line do |line|
        splited = line.split("\t")
	      if (splited[0]==params[:id])
          @post[:timestamp] = splited[0]
	        @post[:email] = splited[1]
          @post[:nickname] = splited[2]
	        @post[:posttext] = splited[3]
        end
      end
    end
    #render html: "show"
  end

  def del
    # puts params[:del]
    need_del_params = params[:del]
    is_match_param = false
    newdb = ""
    File.open("post.txt", "r") do |f|
      f.each_line do |line|
        need_del_params.each do |select_date|
          if line.match( /\b#{select_date}\b/i ) then
            is_match_param = true
            break
          end
        end
        if is_match_param then
          is_match_param = false
          next
        else
          newdb += line
        end
      end
    end
#    puts newdb
    File.open("post.txt", "w") do |f|
      f.write newdb
    end
    redirect_to "/posts"
  end
end
