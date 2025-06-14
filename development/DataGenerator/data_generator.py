import psycopg2
import random
import time
from datetime import datetime, timedelta
import string
import os
import logging
import sys
from dotenv import load_dotenv

# Configure logging with immediate flushing
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)],
    force=True
)

# Ensure immediate flushing
logging.getLogger().handlers[0].flush = lambda: sys.stdout.flush()

# Load environment variables
load_dotenv()

# Database connection parameters
DB_PARAMS = {
    'dbname': os.getenv('POSTGRES_DB', 'source_db'),
    'user': os.getenv('POSTGRES_USER', 'source_user'),
    'password': os.getenv('POSTGRES_PASSWORD', 'source_password'),
    'host': os.getenv('POSTGRES_HOST', 'dwh-postgres-source'),
    'port': os.getenv('POSTGRES_PORT', '5432')
}

logging.info("Starting data generator with configuration:")
logging.info(f"Database: {DB_PARAMS['dbname']}")
logging.info(f"Host: {DB_PARAMS['host']}")
logging.info(f"Port: {DB_PARAMS['port']}")
logging.info(f"User: {DB_PARAMS['user']}")

def generate_random_username():
    """Generate a random username."""
    return ''.join(random.choices(string.ascii_lowercase, k=8))

def generate_random_email(username):
    """Generate a random email based on username."""
    domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com']
    return f"{username}@{random.choice(domains)}"

def generate_random_name():
    """Generate a random first or last name."""
    return ''.join(random.choices(string.ascii_letters, k=random.randint(4, 10)))

def generate_random_order_amount():
    """Generate a random order amount between 10 and 1000."""
    return round(random.uniform(10, 1000), 2)

def generate_random_status():
    """Generate a random order status."""
    return random.choice(['pending', 'completed', 'cancelled', 'processing'])

def insert_random_user(cursor):
    """Insert a random user into the users table."""
    username = generate_random_username()
    email = generate_random_email(username)
    first_name = generate_random_name()
    last_name = generate_random_name()
    
    logging.info(f"Inserting user: {username} ({email})")
    
    cursor.execute("""
        INSERT INTO users (username, email, first_name, last_name)
        VALUES (%s, %s, %s, %s)
        RETURNING id
    """, (username, email, first_name, last_name))
    
    user_id = cursor.fetchone()[0]
    logging.info(f"Inserted user with ID: {user_id}")
    return user_id

def insert_random_order(cursor, user_id):
    """Insert a random order into the orders table."""
    order_date = datetime.now() - timedelta(days=random.randint(0, 30))
    total_amount = generate_random_order_amount()
    status = generate_random_status()
    
    logging.info(f"Inserting order for user {user_id}: ${total_amount} ({status})")
    
    cursor.execute("""
        INSERT INTO orders (user_id, order_date, total_amount, status)
        VALUES (%s, %s, %s, %s)
    """, (user_id, order_date, total_amount, status))

def main():
    """Main function to generate and insert random data."""
    logging.info("Starting main loop...")
    sys.stdout.flush()  # Force flush at start
    
    while True:
        try:
            logging.info("Attempting to connect to database...")
            # Connect to the database
            conn = psycopg2.connect(**DB_PARAMS)
            cursor = conn.cursor()
            logging.info("Successfully connected to database")
            
            # Generate random number of users (1-3)
            num_users = random.randint(1, 3)
            logging.info(f"Generating {num_users} users...")
            for i in range(num_users):
                logging.info(f"Processing user {i+1}/{num_users}")
                user_id = insert_random_user(cursor)
                
                # Generate random number of orders for each user (1-5)
                num_orders = random.randint(1, 5)
                logging.info(f"Generating {num_orders} orders for user {user_id}")
                for j in range(num_orders):
                    logging.info(f"Processing order {j+1}/{num_orders}")
                    insert_random_order(cursor, user_id)
            
            # Commit the transaction
            conn.commit()
            logging.info(f"Successfully inserted {num_users} users and their orders")
            sys.stdout.flush()  # Force flush after each cycle
            
        except Exception as e:
            logging.error(f"Error occurred: {str(e)}")
            if 'conn' in locals():
                conn.rollback()
                logging.warning("Transaction rolled back")
        
        finally:
            if 'cursor' in locals():
                cursor.close()
                logging.debug("Cursor closed")
            if 'conn' in locals():
                conn.close()
                logging.debug("Connection closed")
        
        logging.info("Waiting 20 seconds before next iteration...")
        sys.stdout.flush()  # Force flush before sleep
        time.sleep(20)

if __name__ == "__main__":
    logging.info("Starting data generator...")
    sys.stdout.flush()
    main() 