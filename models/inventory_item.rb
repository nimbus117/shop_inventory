require_relative '../db/sql_runner.rb'

class InventoryItem
  attr_accessor :name, :manufacturer_id, :cost_price, :sell_price, :quantity, :notes
  attr_reader :id

  def initialize options
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @manufacturer_id = options['manufacturer_id']
    @cost_price = options['cost_price']
    @sell_price = options['sell_price']
    @quantity = options['quantity']
    @notes = options['notes'] || ''
  end

  def save
    sql = '
      INSERT INTO inventory_items
      (
        name,
        manufacturer_id,
        cost_price,
        sell_price,
        quantity,
        notes
      )
      VALUES
      (
        $1, $2, $3, $4, $5, $6
      )
      RETURNING id
    '
    values = [@name, @manufacturer_id, @cost_price, @sell_price, @quantity, @notes]
    result = SqlRunner.run sql, values
    @id = result.first['id'].to_i
  end

  def update
    sql = '
      UPDATE
        inventory_items
      SET
      (
        name,
        manufacturer_id,
        cost_price,
        sell_price,
        quantity,
        notes
      ) = (
        $1, $2, $3, $4, $5, $6
      )
      WHERE id = $7
    '
    values = [@name, @manufacturer_id, @cost_price, @sell_price, @quantity, @notes, @id]
    SqlRunner.run sql, values
  end

  def delete
    sql = 'DELETE FROM inventory_items WHERE id = $1'
    values = [@id]
    SqlRunner.run sql, values
  end

  def manufacturer
    sql = 'SELECT * FROM manufacturers WHERE id = $1'
    values = [@manufacturer_id]
    result = SqlRunner.run sql, values
    Manufacturer.new result[0]
  end

  def InventoryItem.map_items item_data
    item_data.map do |item|
      InventoryItem.new item
    end
  end

  def InventoryItem.all
    sql = 'SELECT * FROM inventory_items'
    result = SqlRunner.run sql
    InventoryItem.map_items result
  end

  def InventoryItem.delete_all
    sql = 'DELETE FROM inventory_items'
    SqlRunner.run sql
  end

  def InventoryItem.get_by_id id
    sql = '
      SELECT *
      FROM inventory_items
      WHERE id = $1
    '
    values = [id]
    result = SqlRunner.run sql, values
    InventoryItem.new result[0]
  end

  def InventoryItem.delete_by_id id
    sql = '
      DELETE FROM inventory_items
      WHERE id = $1
    '
    values = [id]
    SqlRunner.run sql, values
  end

  def InventoryItem.get_by_manufacturer_id id
    sql = '
      SELECT
        I.*
      FROM
        inventory_items AS I
      INNER JOIN
        manufacturers AS M
      ON
        I.manufacturer_id = M.id
      WHERE
        M.id = $1
    '
    values = [id]
    result = SqlRunner.run sql, values
    InventoryItem.map_items result
  end
end
