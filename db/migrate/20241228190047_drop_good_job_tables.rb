class DropGoodJobTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :good_job_settings
    drop_table :good_job_processes
    drop_table :good_job_executions
    drop_table :good_job_batches
    drop_table :good_jobs
  end
end
