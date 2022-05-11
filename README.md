# Scolasti-coin
_An introduction to blockchains_

This project’s goal is to teach you the fundamentals of blockchains: their anatomy and their validation. This project contains broad instructions to guide you, and specs to test your implementation with clear expectations. As you work through this exercise, resist the urge to Google code to copy and paste. Remember: durable knowledge is hard won knowledge. If you’re stuck, reach out to a team member or mentor. Read the instructions completely before starting work on the project. Happy coding!

## Setup
This project is written in Ruby with specs in Rspec. Both are necessary for the project. If you don't already have them installed, please follow the Ruby [installation instructions](https://www.ruby-lang.org/en/documentation/installation/#homebrew), then [install Rspec](https://rspec.info/). Whether you're a Ruby newbie or a veteran, keep the official [Ruby Docs](https://ruby-doc.org/) referenced so you can easily look up syntax and methods.

## Instructions

`git clone` this repository (or download the file [scolasti_coin](https://drive.google.com/file/d/1gCKg-54FmPYtDv14et-SPWSckwkwBa-b/view?usp=sharing)) and open the project in your prefered text editor. Open your terminal, navigate to this project and `cd` into the `skeleton` directory. Run `rspec` in your terminal to see the tests fail. In classic [TDD](https://en.wikipedia.org/wiki/Test-driven_development) style, Your goal is to pass these specs. The `solution` directory next to the `skeleton` is there for your reference when you finish. Don't peek!

### The Block

Start with the `Block` class.  Ask yourself: "what are the fundamental pieces of a block?" List them out, then run the specs just for the block class with this command: `rspec block_chain/block_spec.rb`. Read the failing messages to see any additional properties you should add to your list.

Build the **#initialize** method for the `Block` class.  What arguments does the `Block` Class need to initialize? What data can an instance of `Block` generate internally? Use the specs to guide you.

Ask: what should an instance of `Block` do? Blocks need to produce deterministic hashes based on their data; how might we do that? Instances of `Block` need to provide **proof of work**. Scolasti-coin will expect you to provide proof of work by passing the block an integer, the difficulty, which should determine the number of ending zeroes on the block’s hash.  How can we use a **nonce** to programmatically generate and test hashes until we find one that meets the expectation of difficulty?

Lastly, put together a class method to build a default starting block for a new block chain.  Pick some sensible defaults for its necessary data. Once your `Block` class passes all of its specs, you can test it manually by in your terminal with [irb](https://www.digitalocean.com/community/tutorials/how-to-use-irb-to-explore-ruby)

### The Blockchain
_You’re halfway there!_

Similar to the `Block` class, list out the properties, behaviors, and responsibilities of the `BlockChain`. Run the specs for the `BlockChain` class with this command in the terminal: `rspec block_chain/block_chain_spec.rb` and let the failure messages fill in gaps in your list.

Build the initialize method for the `BlockChain` class.  For this implementation, have the `BlockChain` store the list of blocks in a Ruby Array. The `BlockChain` should also track the difficulty for  **proof of work**.


Ask, what should a `BlockChain` do? Separate the logic of building a new block from adding a block to the chain. What are the differences in responsibilities between these two behaviors? Define a method that validates the entire chain. What makes a chain valid? By inspecting the **previous hash**, the **block hash** of a block, and the output of the **#compute_hash** method, how can we verify every block in the chain is legitimate? 

Once you pass your specs, test out your new Block Chain in irb. Congratulations! You just made your very own Block Chain! Feel free to check out the `solution` directory to compare your implementation to another example.

## Bonus
If you've got some extra time on your hands think about, and try to implement, the following:
- Our implementation uses an array for the list of blocks; what other data structures could be used for the list?  How would you implement the list using them?
   - How could we maintain an O(1) lookup for blocks in the chain with these data structures (or a combination of data structures)? Do the indices for blocks in the chain need to be sequential?
- You’ve created the blockchain, but what about the network of nodes that monitor, read, and add to the chain? Write a high level spec for what you think the code that facilitates that network should do. Think about:
   - How does it deliver the existing chain to new nodes?
   - How does it deliver newly “mined” blocks to existing nodes?
   - If a node gets two different chains and both are valid, how does it choose one?
   - How does a “miner” receive new blocks? What happens if they were in the middle of mining a block (looking for the nonce to their data)?
   - How might it prevent duplicate data from being added to new blocks?
