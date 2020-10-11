# Queues Dashboard 
The Transeo Queues Dashboard wraps around the data from the `queues-database-hooks` package to show information about queue jobs in a dashboard. Here's what it looks like:


| Dashboard | Jobs List | Job View |
| -- | -- | -- |
|![Screenshot 1](https://i.imgur.com/mDnk52c.png)|![Screenshot 2](https://i.imgur.com/PXx3I9P.png)|![Screenshot 3](https://i.imgur.com/FyTMQdX.png)|

## Why?
We use Queues extensively at Transeo (we authored the Vapor package!) and they power all of the most critical parts of our infrastructure. However, we didn't have a great way to get immediate visibility into the health of our queues and if anything was getting stuck. We found ourselves firing up our VPN, connecting the Redis box, and then running commands directly in Redis to figure out what was up. 

That led us to initially create https://github.com/gotranseo/queues-progress, a little CLI that shows you information about which jobs are hanging out in your processing queue. While that gave us great visibility into the current jobs being run, it didn't do anything to show us the status of the historical jobs. In fact, there was no mechanism for us to even keep data about historical jobs other than our logs. 

This dashboard combines the best of our make-shift solutions. Building upon the new [job event delegate](https://github.com/vapor/queues/releases/tag/1.5.0) feature we wrote the [database tracking package](http://github.com/vapor-community/queues-database-hooks) that stores all of the historical information about jobs. 

If you layer all of these tools together, this `queues-dash` package can sit on top of your data and observe + surface insights. 

## Getting Started
The `queues-dash` is a standalone project that does not get added as a library to an existing application. It comes with its own Leaf views and database logic. All you need to do is clone the repository, set the `DATABASE_URL` env var, and run the application. 

The database that is passed into the project needs to have the `_queue_job_completions` table migrated already via the [QueuesDatabaseHooks](http://github.com/vapor-community/queues-database-hooks) package. Follow the instructions in that repo for more information. 

**Note:** One of the limitations right now is that the application only supports `MySQL` - we're looking for ways to make this more configurable in the future.

## Configuring
There aren't any configuration options available because there's nothing to configure - the dashboard is intentionally opinionated. However, we specifically built this as an application and not a library/package because once you've cloned the repo you can change anything you need to fit your usecase. If you want to change the frontend colors (The frontend is built with Tailwind UI) or the way data is displayed, go for it! Even better, submit a PR and we'll take a look to see if it fits with the vision of the project.  

## Using in Production
The `queues-dash` application does not include any authentication out of the box. If you'd like to protect the dashboard, we suggest running it behind some kind of firewall or service that can limit access to your employees. 

## Current Shortcomings
This is an early stage project so we know not everything is here yet... here's a list of what we've captured on our end for the future:

1. Support all SQL databases 
2. Retry failed jobs right from the dashboard 
3. More metrics and graphs about statuses 
4. Alerting when specific jobs fails 
5. Seeing data on a per-job basis (i.e. "show me the failure rate for my `EmailJob`")
