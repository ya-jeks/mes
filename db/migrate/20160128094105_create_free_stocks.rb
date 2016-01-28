class CreateFreeStocks < ActiveRecord::Migration
  def up
    execute %(create or replace view free_stocks as
      select t.*
      from tasks t
      left join task_relations tr on tr.task_id = t.id
      left join tasks p on p.id = tr.parent_id
      where t.state = 'finished' and p.id is null;
    )
  end

  def down
    execute "drop view free_stocks;"
  end
end
