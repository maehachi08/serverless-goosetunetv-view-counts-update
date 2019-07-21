# -*- encoding: utf-8 -*-
require "rubygems"
require 'mysql2'
require "active_record"
require 'goosetune'

# connect to MySQL with authentication
ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  encoding: 'utf8',
  #socket:   '/tmp/mysql.sock',
  #username: 'root',
  host:     'goosetunetv-development.ceq1pdgylh31.ap-northeast-1.rds.amazonaws.com',
  username: 'goosetunetv',
  password: 'goosetunetv',
  database: 'goosetunetv_development'
)

class Youtube < ActiveRecord::Base
  # 主キー設定
  # refs http://qiita.com/k-shogo/items/884498ad512c0e6eb303
  self.primary_key = :id

  def self.update_view_counts
    goosetune = Goosetune::Youtube::Video.new
    view_counts = goosetune.get_view_counts
    view_counts.keys.each do |id|
      next unless Youtube.exists?(:id => id)
      Youtube.find(id).update_attributes(:view_counts => view_counts[id])
    end
  end
end

def lambda_handler(event:, context:)
  youtube_channnel_ids = [
    # playyouhousejp
    'UCFDL0NuxUBAvvu1PnIwW2ww',

    # playgoose
    'UCx66obAJ42B0XwHIm_iupkw'
  ]

  # playgoose
  %w( 2018 2019 ).each do |year|
    goosetune = Goosetune::Youtube::Video.new(youtube_channnel_id="UCx66obAJ42B0XwHIm_iupkw")
    view_counts = goosetune.get_view_counts_by_year(year=year)
    view_counts.keys.each do |id|
      next unless Youtube.exists?(:id => id)
      entry = Youtube.find(id)
      entry.update_attributes(:view_counts => view_counts[id])
      puts "[INFO] #{entry.title} view_counts to #{view_counts[id]}."
      puts "[INFO] #{entry.title} view_counts updated."
    end
  end

  # goosehouse
  %w( 2010 2011 2012 2013 2014 2015 2016 2017 2018 ).each do |year|
    goosetune = Goosetune::Youtube::Video.new(youtube_channnel_id="UCFDL0NuxUBAvvu1PnIwW2ww")
    view_counts = goosetune.get_view_counts_by_year(year=year)
    view_counts.keys.each do |id|
      next unless Youtube.exists?(:id => id)
      entry = Youtube.find(id)
      entry.update_attributes(:view_counts => view_counts[id])
      puts "[INFO] #{entry.title} view_counts to #{view_counts[id]}."
      puts "[INFO] #{entry.title} view_counts updated."
    end
  end
end

event = {}
context = {}
lambda_handler(:event => {}, :context => {})
