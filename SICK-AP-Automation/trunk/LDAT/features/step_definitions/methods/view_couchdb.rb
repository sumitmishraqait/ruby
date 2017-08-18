require 'rubygems'
require 'colorize'
require 'couchrest'

# Do Not Remove This File

class ViewCouchDB
  def setup(database_name, couchdb_ip)
    couch = CouchRest.new("http://#{couchdb_ip}:5984")
    db_name = couch.database("#{database_name}")
    design_doc_id = "_design/testing"
    return db_name, design_doc_id
  end

# Try to create a testing design document with a by_automation view and if it already exists, update the existing one by getting its rev number
  def save_or_create(db, doc_id)
    begin
      puts "Trying to create a new testing design document with a view by_automation...".cyan
      db.save_doc({"_id" => doc_id, :views => { :by_automation => { :map => "function(doc) { if (doc.content.testing == 'SELCUKE') { emit(doc.content.general.oi, doc._id); } }" } } })
    rescue CouchRest::Conflict => nfe
      puts "Design document already exists, updating existing design document with view...".yellow
      doc = db.get('_design/testing')
      rev = db.get(doc['_id'])['_rev']
      db.save_doc({"_id" => doc_id, "_rev" => rev, :views => { :by_automation => { :map => "function(doc) { if (doc.content.testing == 'SELCUKE') { emit(doc.content.general.oi, doc._id); } }" } } })
      puts "Updated testing design document with rev# \"#{rev}\"".cyan
    end
  end

# Try to filter the view created by oi key
  def filter_view_by_oi(db, oi)
    params = {
      :key => oi
    }

    json = db.view('testing/by_automation', params)['rows'] # this filtered query in view will return a json for the oi we searched for

    if json.is_a?(Array)
      return json.first['key'], json.first['id'] # key field contains the value of oi & id field contains the id of the doc which will be used for data cleanup later
    else
      puts "Either json returned is not an array OR the oi passed in filter query is not present in CouchDB.".red
      return nil
    end
  end

# Try to filter the view created by oi key range for future use if needed
  def filter_view_by_oi_range(db, soi, eoi)
    params = {
      :startkey => soi,
      :endkey => eoi
    }
    return db.view('testing/by_automation', params)['rows'].inspect
  end

  def teardown(db, id)
    db.delete_doc db.get(id) rescue nil
    #db.delete_doc db.get("_design/testing") rescue nil # to delete the design document and view created by the script
    #db.delete! rescue nil # to delete the full database
  end
end