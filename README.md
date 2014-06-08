# Elb

[![Build Status](https://travis-ci.org/tongueroo/elb.svg?branch=master)](https://travis-ci.org/tongueroo/elb)
[![Code Climate](https://codeclimate.com/github/tongueroo/elb.png)](https://codeclimate.com/github/tongueroo/elb)
[![Code Climate](https://codeclimate.com/github/tongueroo/elb/coverage.png)](https://codeclimate.com/github/tongueroo/elb)

Tool gracefully restarts app server without affecting users by deregistering the instance from the elb, restarting it and registering it back to the elb.  

It makes the assumption that the instance belongs to an autoscaling group that was created with cloudformation.  Cloudformation automatically tags these instances with a `aws:autoscaling:groupName` tag, which is required.

## Installation

```
$ gem install elb
```

## Setup

The tool requires access to a limited number of AWS resources.  This tool is meant to be ran on an ec2 instance, so using an IAM role is ideal.  An [example IAM policy](https://github.com/tongueroo/elb/wiki/IAM-Role-Example) is on the wiki.

If you cannot use IAM roles, you can use a credentials file instead.  The location of the file should be at ~/.br/aws.yml.  An example of the format of the file is provided [here](https://github.com/tongueroo/elb/blob/master/spec/fixtures/aws.yml).

## Usage

```
$ elb restart
```
The `elb restart` command is meant to be ran on an ec2 instance and does the following:

1. deregister the instance from the autoscaling group it's associated with
2. restart the app
3. warm up the app by hitting it with a local curl request
4. register the instance back to the elb

Options can be used to override default behaviors.

```
$ elb restart --wait 30 # wait 30 seconds after deregistering

$ elb restart --warm-command "curl -s -v -o /dev/null localhost/custom-warm-url 2>&1 | grep '< HTTP'"

$ elb restart --restart-command "restart nginx"

$ elb help
```

### Local Usage

You can also use the tool locally and test on remote ec2 instances by specifying the `--instance-id` option.  

```bash
$ elb restart --instance-id i-xxxxx

$ elb deregister --instance-id i-xxxxx # only runs deregister part

$ elb register --instance-id i-xxxxx # only runs register part
```