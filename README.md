# Create features
## Interactive mode
- ./create_feature.sh

## Direct mode
- ./create_feature.sh product_management

# Database operations

## First, initialize the database helper:

final dbHelper = DatabaseHelper();

## Basic CRUD operations:

- Create
int id = await dbHelper.create('users', {'name': 'John', 'email': 'john@example.com'});

- Read
var user = await dbHelper.find('users', id);

- Update
await dbHelper.update('users', id, {'name': 'Updated Name'});

- Delete
await dbHelper.delete('users', id);

## Query operations:

- Get all records
var allUsers = await dbHelper.all('users');

- Pagination
var pagedUsers = await dbHelper.paginate('users', page: 1, perPage: 10);

- Custom queries
var activeUsers = await dbHelper.all(
  'users',
  where: 'status = ?',
  whereArgs: ['active'],
  orderBy: 'name ASC'
);

